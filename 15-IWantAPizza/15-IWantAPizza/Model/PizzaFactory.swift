//
//  PizzaFactory.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation


public class PizzaFactory  {
    
    private var pizzas: [Pizza]!
    
    public init() {
        do {
            if let url = Bundle.main.url(forResource: "pizzas", withExtension: "json") {
                let data = try Data(contentsOf: url)
                self.pizzas = try JSONDecoder().decode([Pizza].self, from: data)
            }
        }
        catch {
            print(error)
        }
    }
    
    public func getPizzas() -> [Pizza] {
        return self.pizzas
    }
    
}


