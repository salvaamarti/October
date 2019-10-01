//
//  Order.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 30/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation


public class Order: Codable, Hashable, Equatable {

    
    private static var numOrder: Int = 0
    private var number: Int
    private var pizza: Pizza
    private var total: Float
    
    private var description: String
    
    
    public init(pizza:Pizza,total:Float) {
        self.number = Order.newOrder()
        self.pizza = pizza
        self.total = total
        self.description = "\(self.pizza.getName()) pizza"
        
        if(pizza.getExtraToppings().count > 0) {
            self.description += " with extra toppings:"
            for t in pizza.getExtraToppings() {
                self.description += " \(t.getName()),"
            }
            self.description.remove(at: self.description.index(before: self.description.endIndex))
            self.description += "."
            
        }
    }
    
    public init?(from data: Data?) {
        guard let data = data else {return nil}
        
        let decoder = JSONDecoder()
        
        guard let savedOrder = try? decoder.decode(Order.self, from: data) else {return nil}
        
        self.number = Order.newOrder()
        self.pizza = savedOrder.getPizza()
        self.total = savedOrder.getOrderTotalPrice()
        self.description = savedOrder.getDescription()
        
    }
    
    
    
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.number == rhs.number
    }
    
    
    private static func newOrder() -> Int {
        Order.numOrder += 1
        return Order.numOrder
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.number)
    }
    
    public func getNumOrder() -> Int {
        return self.number
    }
    
    public func getPizza() -> Pizza {
        return self.pizza
    }
    
    public func getOrderTotalPrice() -> Float {
        return self.total
    }
    
    public func getDescription() -> String {
        return self.description
    }
    
    
}
