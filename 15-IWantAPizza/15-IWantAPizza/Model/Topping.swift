//
//  Topping.swift
//  15-IWantAPizza
//
//  Created by Salvador Martí Solsona on 29/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation

public class Topping : Codable, CustomStringConvertible, Equatable, Hashable {

    private var name : String
    private var info : String
    private var priceExtra : Float
    private var checked : Bool?
    
    
    public var description: String {
        return """
        Topping!
        Name: \(self.name)
        Extra info: \(self.info)
        Price out of letter: \(self.priceExtra)
        """
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case info = "info"
        case priceExtra = "price"
    }
    
    
    public init() {
        self.name = ""
        self.info = ""
        self.priceExtra = 0.0
    }
    
    public init(name : String, description: String, price : Float) {
        self.name = name
        self.info = description
        self.priceExtra = price
    }
    
    public init(name: String) {
        self.name = name
        self.info = ""
        self.priceExtra = 0.0
    }
    
    public init(name: String, price: Float) {
        self.name = name
        self.info = ""
        self.priceExtra = price
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getDescription() -> String {
        return self.info
    }
    
    public func setDescription(description: String) {
        self.info = description
    }
    
    public func getPriceExtra() -> Float {
        return self.priceExtra
    }
    
    public func setPriceExtra(extra: Float) {
        self.priceExtra = extra
    }
    
    public static func == (lhs: Topping, rhs: Topping) -> Bool {
        return lhs.getName() == rhs.getName()
    }
    
    public func makeChecked() -> Void {
        self.checked = true
    }
    
    public func makeUnchecked() -> Void {
        self.checked = false
    }
    
}
