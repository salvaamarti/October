//
//  OrderViewController.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 30/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit
//Módulo para voz de Siri
import Intents

class OrderViewController: UIViewController {

    
    @IBOutlet weak var pizzaName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pizzaToppics: UILabel!
    
    
    var finalPizza : Pizza!
    var finalPrice : Float!
    
    var newOrder : Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = self.image.bounds.width / 2
        
        
        self.image.image = UIImage(named: self.finalPizza.getName())
        self.totalPrice.text = "Total order: \(self.finalPrice!) €"
        self.pizzaName.text = "\(self.finalPizza.getName()) pizza"
        
        
        self.navigationItem.title = "Order done!"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAndGoBack))
        
        self.newOrder = Order(pizza: self.finalPizza, total: self.finalPrice)
        self.pizzaToppics.text = self.newOrder.getDescription()
        
        //Donar el pedido a Siri
        self.donate(self.newOrder)
        
        
        
    }
    
    
    
    public func sendToServer(order: Order) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self.newOrder)
            print(data)
        } catch {
            print("Error al codificar la order")
        }
    }
    
    @objc func doneAndGoBack() -> Void {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Configuración de shortcurts para SIRI
    public func donate(_ order: Order) {
        let activity = NSUserActivity(activityType: "com.salvadormarti.IWantAPizza.order")
        
        let orderDescription = order.getDescription()
        
        activity.title = "I want a \(orderDescription)"
        
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        
        
        let encoder = JSONEncoder()
        
        if let orderData = try? encoder.encode(order) {
            activity.userInfo = ["order" : orderData ]
        }
            
        
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(orderDescription)
        
        activity.suggestedInvocationPhrase = "I want a pizza!"
        
        self.userActivity = activity
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
