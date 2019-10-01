//
//  ExtraToppingsViewController.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit

class ExtraToppingsViewController: UIViewController {

    
    var allToppings : [Topping] = ToppingFactory().getToppings()
    var restToppings : [Topping]?
    var selectedPizza : Pizza?
    var total : Float = 0.0
    
    
    @IBOutlet weak var extraTableView: UITableView!
    @IBOutlet weak var extraPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extraTableView.delegate = self
        self.extraTableView.dataSource = self

        // Do any additional setup after loading the view
        self.restToppings = allToppings.filter { (topping) -> Bool in
            return !self.selectedPizza!.getToppings().contains(topping)
        }
        
        self.total = self.selectedPizza!.getPrice()
        
        
        for t in self.selectedPizza!.getExtraToppings() {
            self.total += t.getPriceExtra()
        }
        
        self.extraPrice.text = "Total: \(self.total) €"
        //print(self.restToppings!.count)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "\(self.selectedPizza!.getName()): Extra toppings"
    }
    
    
    @IBAction func orderNowPressed(_ sender: UIBarButtonItem) {
        
        guard let orderVC = storyboard?.instantiateViewController(withIdentifier: "OrderVC") as? OrderViewController else {
            fatalError("Error al instanciar el view controller del pedido desde el storyboard")
        }
        
        orderVC.finalPizza = self.selectedPizza!
        orderVC.finalPrice = self.total
        navigationController?.pushViewController(orderVC, animated: true)
        
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


extension ExtraToppingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restToppings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraToppingCell", for: indexPath)
        
        cell.textLabel!.text = self.restToppings![indexPath.row].getName()
        cell.detailTextLabel!.text = "\(self.restToppings![indexPath.row].getPriceExtra()) €"
        
        let selectedTopping = self.restToppings![indexPath.row]
        
        if(self.selectedPizza!.getExtraToppings().contains(selectedTopping)) {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTopping = self.restToppings![indexPath.row]
        
        if(self.selectedPizza!.getExtraToppings().contains(selectedTopping)) {
            self.selectedPizza!.deleteExtraTopping(topping: selectedTopping)
            self.total -= Float(selectedTopping.getPriceExtra())
        }
        else {
            self.selectedPizza!.addExtraTopping(topping: selectedTopping)
            self.total += selectedTopping.getPriceExtra()
        }
        
        self.extraPrice.text = "Total: \(self.total) €"
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        //self.selectedPizza?.addExtraTopping(topping: )
        
        
    }
    
    

}

