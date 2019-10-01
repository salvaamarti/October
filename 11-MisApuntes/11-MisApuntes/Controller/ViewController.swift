//
//  ViewController.swift
//  11-MisApuntes
//
//  Created by Salvador Martí Solsona on 24/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    //Class attr
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //Class variables
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var apuntes : [Annotation] = [Annotation]()
    
    var apunteSeleccionado : Annotation = Annotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //DataSource & Delegate of tableView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        self.loadAnnotations()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromNoteToBody") {
            let bodyVC = segue.destination as! BodyViewController
            //let chat2Controller = segue.destination as! Chat2UserViewController
            //chat2Controller.email = self.userSelected.getEmail()
            
            bodyVC.apunte = self.apunteSeleccionado
         }
        //print("Prepare for segue")
            
        
    }

    @IBAction func addNote(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let controller = UIAlertController(title: "New note", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add note", style: .default) { (action) in
            //TODO: Recuperar lo que haya escrito el usuario en el textfield cuando pulsa el botón Añadir
            
            if textField.text!.count > 0 {
                let apunte = Annotation(context: self.context)
                apunte.title = textField.text!
                apunte.body = ""
                self.apuntes.append(apunte)
                self.persistAnnotations()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addAction(addAction)
        controller.addAction(cancelAction)
        
        controller.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write a note title"
            textField = alertTextField
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Data persistence and manipulation
    func persistAnnotations() {
        
        do{
            try context.save()
        }catch{
            print("Error al intentar guardar el contexto: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadAnnotations(from request: NSFetchRequest<Annotation> = Annotation.fetchRequest(), predicate: NSPredicate? = nil) -> Void {
        
        if let previousPredicte = predicate{
            //aquí tenemos un predicado de búsqueda previo
            //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [previousPredicte, categoryPredicate])
            request.predicate = previousPredicte
        }
        
        do {
            self.apuntes = try context.fetch(request)
        } catch {
            print("Error al recuperar datos de Core Data \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    


}


//MARK: - Extensión con DataSource y Delegado de UITableView

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apuntes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let annotationTitle = self.apuntes[indexPath.row].title
        
        
        cell.textLabel?.text = annotationTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.apunteSeleccionado = self.apuntes[indexPath.row]
        //print("Celda seleccionada")
        self.performSegue(withIdentifier: "fromNoteToBody", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete note", message: "¿Are you sure you want to delete this note?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {
                (alert:UIAlertAction!) in
                
                self.context.delete(self.apuntes[indexPath.row])
                self.apuntes.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                self.persistAnnotations()
                
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

//MARK: - Extensión con Delegate del UISearchBar

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        let request : NSFetchRequest<Annotation> = Annotation.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        
        if searchBar.text!.count == 0 {
            self.loadAnnotations(from: request, predicate: nil)
        }
        else {
             //[cd] para no tener en cuenta mayusculas ni acentos.
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            self.loadAnnotations(from: request, predicate: predicate)
        }
        
        searchBar.resignFirstResponder()
        
    }
    
    
    //Método del delegado del SearchBar que se ejecuta cuando el usuario hace click en la X de borrar o cuando borra todo el contenido del la field
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Cuando no haya texto
        if searchBar.text?.count == 0 {
            self.loadAnnotations()
            
            //Esto se tiene que ejecutar mediante el gran central dispacher, en el hilo ppal, sino no se entera y no se esconde el teclado
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


