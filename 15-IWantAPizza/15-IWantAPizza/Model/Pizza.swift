//
//  Pizza.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation

public class Pizza : Codable, CustomStringConvertible{
    
    private var name : String
    private var info : String
    private var price : Float
    private var toppings : [Topping]
    private var extraToppings : Set<Topping>?
    
    
    public var description: String {
        let firstPart = """
        Pizza!
        Name: \(self.name)
        Description: \(self.info)
        Price: \(self.price)
        """
        
        var secondPart = "Ingredients: "
        for topping in toppings {
            secondPart += topping.getName() + " "
        }
        secondPart += "\n"
        
        return "\(firstPart) \(secondPart)"
    }
        
    
    public init() {
        self.name = ""
        self.info = ""
        self.price = 0.0
        self.toppings = [Topping]()
    }
    
    public init(name: String, info: String, price: Float, toppings : [Topping]) {
        self.name = name
        self.info = info
        self.price = price
        self.toppings = toppings
    }
    
    public init(name: String, info: String, toppings : [Topping]) {
        self.name = name
        self.info = info
        self.price = 0.0
        self.toppings = toppings
    }
    
    public init(name: String, toppings : [Topping]) {
        self.name = name
        self.info = ""
        self.price = 0.0
        self.toppings = toppings
    }
    
    public init(name: String, price: Float, toppings : [Topping]) {
        self.name = name
        self.info = ""
        self.price = price
        self.toppings = toppings
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getInfo() -> String {
        return self.info
    }
    
    public func setInfo(info: String) -> Void {
        self.info = info
    }
    
    public func getPrice() -> Float {
        return self.price
    }
    
    public func setPrice(price: Float) -> Void {
        self.price = price
    }
    
    public func getToppings() -> [Topping] {
        return self.toppings
    }
    
    public func addExtraTopping(topping : Topping) {
        
        if (self.extraToppings == nil) {
            self.extraToppings = Set<Topping>()
            
        }
        self.extraToppings!.insert(topping)
    }
    
    public func getExtraToppings() -> Set<Topping> {
        guard self.extraToppings != nil else {
            self.extraToppings = Set<Topping>()
            return self.extraToppings!
        }
        return self.extraToppings!
    }
    
    public func deleteExtraTopping(topping : Topping) -> Void {
        
        self.extraToppings!.remove(topping)
    }
    
}


