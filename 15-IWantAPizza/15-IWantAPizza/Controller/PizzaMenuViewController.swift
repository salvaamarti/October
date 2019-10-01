//
//  ViewController.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 28/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit

class PizzaMenuViewController: UITableViewController {

    //Class variables
    let allPizzas : [Pizza] = PizzaFactory().getPizzas()
    //let allToppings : [Topping] = ToppingFactory().getToppings()
    
    var pizza : Pizza?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "PCell", bundle: nil), forCellReuseIdentifier: "PCell")
        //self.tableView.register(PizzaCell.self, forCellReuseIdentifier: "PizzaCell")
        //self.tableView.register(UINib(nibName: "PizzaViewCell", bundle: nil), forCellReuseIdentifier: "PizzaCell")
        
        
        self.configureTableView()
    }
    
    //MARK: - Configuración de la celda
    //MARK: - Funciones de la clase (privadas)
    private func configureTableView() -> Void {
        self.tableView.rowHeight = 140
        self.tableView.estimatedRowHeight = 240
    }
    
    
    
    //MARK: - Delegado y DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCell", for: indexPath) as! PCell
        
        cell.name.text = self.allPizzas[indexPath.row].getName()
        //cell.price.text = "\(self.allPizzas[indexPath.row].getPrice()) €"
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pizza = self.allPizzas[indexPath.row]
        performSegue(withIdentifier: "fromPizzaToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromPizzaToInfo") {
      
            let pizzaVC = segue.destination as! ViewController
            pizzaVC.selectedPizza = self.pizza!
            
        }
    }


}

