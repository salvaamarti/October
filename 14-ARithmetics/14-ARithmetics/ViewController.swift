//
//  ViewController.swift
//  14-ARithmetics
//
//  Created by Salvador Martí Solsona on 28/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


enum mathOperations : CaseIterable {
    case sum, substract, multiply, divide
}


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var oktImageView: UIImageView!
    
    
    //Attr
    var correctAnswer : Int? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.askNewQuestion()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        
        //Asignamos el cto de imágenes que queremos trackear a AR
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Numbers", bundle: nil) else {
            fatalError("No se han podido cargar las imágenes para AR")
        }
        //------------------------------------------------------------
        //Configuramos
        configuration.trackingImages = trackingImages
        //Máximo número de imágenes trackeadas
        configuration.maximumNumberOfTrackedImages = 2
        //-------------------------------------------------------------
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    
    // Override to create and configure nodes for anchors added to the view's session.
    //Este método se llama cuando se detecta un objeto ANCLA, es decir, un objeto estudiado por ARKit.(En nuestro caso los numeros)
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        //Conseguir el ImageAnchor
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        //Recuperar nombre de la imagen (ARMuseums)
        //guard let nameImage = imageAnchor.referenceImage.name else {return nil}
        
        
        //creamos el plano con la anchura y altura de nuestras imagenes
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height )
        //Pintamos el material de verde flojo
        plane.firstMaterial?.diffuse.contents = UIColor(displayP3Red: 38.0/255.0, green: 210.0/255.0, blue: 68.0/255.0, alpha: 0.3)
        
        //Ahora el plano hay que colocarlo sobre la imagen
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -Float.pi / 2.0
        ///----------------------------------------------
        
        
        let node = SCNNode()
        //node.opacity = 1
        node.addChildNode(planeNode)
        return node
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    
    //MARK : - Métodos del juego propiamente dichos
    func createNewOperation() -> (question: String, result : Int) {
        
        let operation = mathOperations.allCases.randomElement()!
        var question : String
        var answer : Int
        
        //DO - WHILE (Java)
        repeat {
            switch operation {
                
            case .sum:
                let x = Int.random(in: 1...49)
                let y = Int.random(in: 1...49)
                question = "\(x) + \(y) = ??"
                answer = x + y
                
            case .substract:
                let x = Int.random(in: 51...99)
                let y = Int.random(in: 1...50)
                question = "\(x) - \(y) = ??"
                answer = x - y

            case .multiply:
                let x = Int.random(in: 1...10)
                let y = Int.random(in: 1...9)
                question = "\(x) x \(y) = ??"
                answer = x * y
                
            case .divide:
                let x = Int.random(in: 50...99)
                let y = Int.random(in: 1...49)
                question = "\(x) / \(y) = ??"
                answer = Int(x / y)
            
            }
        }
        while !answer.hasUniqueDigits
    
        return (question, answer)
        
    }
    
    
    func askNewQuestion() -> Void {
        
        let newQuestion = createNewOperation()
        
        self.questionLabel.text = newQuestion.question
        self.correctAnswer = newQuestion.result
        
        questionLabel.alpha = 0.0
        
        UIView.animate(withDuration: 1.0) {
            self.questionLabel.alpha = 1.0
            self.oktImageView.alpha = 0.0
            self.oktImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    
    }
    
    func answerIsCorrect() {
        self.oktImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    
        UIView.animate(withDuration: 1.0) {
            self.oktImageView.alpha = 1.0
            self.oktImageView.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            self.askNewQuestion()
        }
        
    }
    
    //Sobreescribir el metodo de SceneKit para el reconocimiento y transformación de imagenes a números
    //Se llama a cada frame de actualización
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //1. Obtener la lista de anclas que hay actualmente en la pantalla.
        guard let anchorsList = sceneView.session.currentFrame?.anchors else { return }
        //2. Filtrar las anclas que son imágenes y eliminar las que no sean imágenes o las que no están en pantalla
        let visibles = anchorsList.filter {
            //elimino todo lo que no me interesa, lo que no son imagenes
            guard let anchor = $0 as? ARImageAnchor else {return false}
            //solo me quedo con las que están siendo trackeadas
            return anchor.isTracked
        }
        //3. Ordenar la lista de anclas (imágenes) visibles de izquierda a derecha (por su posición en X)
        let nodes = visibles.sorted { (archor1, archor2) -> Bool in
            guard let node1 = sceneView.node(for: archor1) else {return false}
            guard let node2 = sceneView.node(for: archor2) else {return false}
            //Si hemos pasado aqui es que hay dos imagenes, osea dos nodos.
            return node1.worldPosition.x < node2.worldPosition.x
        }
        // izquierda < derecha
        
        //4. De las imágenes extraeremos sus nombres y de ahí sus números
        let stringAnswer = nodes.reduce("") {
            //Empiezo en vacío, y añado el nombre de la imagen ( el numero) si existe otro detras.
            $0 + ($1.name ?? "")
            // ""
            // "" + "3"
            // "3" + "4"
            //"34"
            /* ES LO MISMO
             var solucion = ""
             for node in nodes {
                solucion += node.name ?? ""
             }
             */
        }
        //5. Convertiremos el string a entero
        let answerOfUser : Int = Int(stringAnswer) ?? 0
        //6. Comprobar si el entero es igual al correct answer
        if answerOfUser == self.correctAnswer {
            //Anular la respuesta correcta para evitar problemas en el proximo frame
            self.correctAnswer = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.answerIsCorrect()
            }
            
        }
        
        
        
    }
    
    //Decodificar fichero JSON
    /*
     
     //MARK: Manage data
     func loadPaintingsData(){
     
         guard let url = Bundle.main.url(forResource: "paintings", withExtension: "json") else {
            fatalError("No hemos podido localizar la información de los cuadros...")
         }
     
         guard let jsonData = try? Data(contentsOf: url) else {
            fatalError("No se ha podido leer la información del JSON")
         }
     
         let jsonDecorder = JSONDecoder()
            guard let decodedPaitings = try? jsonDecorder.decode([String:Paiting].self, from: jsonData)
     
         else { fatalError("Problemas al procesar el fichero JSON") }
     
            self.paintings = decodedPaitings
     }
 
 
 
 
 
 
 
   */
    
    
    
    
}
