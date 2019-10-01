//
//  ToppingFactory.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation


public class ToppingFactory {
    
    private var toppings: [Topping]!
    
    public init() {
        do {
            if let url = Bundle.main.url(forResource: "toppings", withExtension: "json") {
                let data = try Data(contentsOf: url)
                self.toppings = try JSONDecoder().decode([Topping].self, from: data)
            }
        }
        catch {
            print(error)
        }
    }
    
    public func getToppings() -> [Topping] {
        return self.toppings
    }
    
}
