//
//  ViewController.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Class attr
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var toppingsTable: UITableView!
    @IBOutlet weak var price: UILabel!
    
    
    var selectedPizza : Pizza?
    var pizzaToppings : [Topping]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.toppingsTable.delegate = self
        self.toppingsTable.dataSource = self
        self.configureTableView()
        
        self.photo.layer.masksToBounds = true
        self.photo.layer.cornerRadius = self.photo.bounds.width / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.photo.image = UIImage(named: self.selectedPizza!.getName())
        self.info.text = self.selectedPizza!.getInfo()
        self.price.text = "\(self.selectedPizza!.getPrice()) €"
        self.navigationItem.title = self.selectedPizza!.getName()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toExtraToppings") {
            
            let extraPizzaVC = segue.destination as! ExtraToppingsViewController
            extraPizzaVC.selectedPizza = self.selectedPizza
            
        }
    }
    
    
    @IBAction func moreToppingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toExtraToppings", sender: self)
    }
    
}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Configuración de la celda
    private func configureTableView() -> Void {
        self.toppingsTable.rowHeight = 70
        self.toppingsTable.estimatedRowHeight = 70
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedPizza?.getToppings().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingCell", for: indexPath)
        
        
        cell.textLabel!.text = self.selectedPizza!.getToppings()[indexPath.row].getName()
        cell.detailTextLabel!.text = self.selectedPizza!.getToppings()[indexPath.row].getDescription()
        
        return cell
        
    }
    
    
}
