//
//  DrinksModel.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import Foundation

struct DrinksModel {
    let drinksCount = 10
    var drinksListItem = [String]()
    var currentDrink: drinkPick = .latte
    var currency = "€"
    var cost:String
    enum drinkPick: String {
        case frappe = "frappe_straw"
        case latte = "latte_straw"
    }
    var prices : [drinkPick : Int] = [.frappe: 10, .latte: 15]
    var currentDrinkIndex = 1
    var backgroundDrinkIndex = 0
    var animatedLast = false
    
    mutating func switchDrinks () {
        currentDrinkIndex = currentDrinkIndex + backgroundDrinkIndex
        backgroundDrinkIndex = currentDrinkIndex - backgroundDrinkIndex
        currentDrinkIndex = currentDrinkIndex - backgroundDrinkIndex
        switch currentDrink {
            case .frappe : currentDrink = .latte
            case .latte :currentDrink = .frappe
        }
    }
    init() {
        cost = "0" + self.currency
    }
    
    mutating func buy(drink: drinkPick) {
        let sequence = cost.split(separator: Character(currency))
        let oldCost = sequence[sequence.startIndex]
        let newCost = Int(oldCost)! + prices[drink]!
        cost = String(newCost) + currency
        print(cost)
    }
    
    mutating func drop(drink: String) {
        let removedPrice : Int
        switch drink {
            case "frappe_straw":
                removedPrice = prices[.frappe]!
            case "latte_straw":
                removedPrice = prices[.latte]!
        default:
            removedPrice = 0
        }
        let sequence = cost.split(separator: Character(currency))
        let oldCost = sequence[sequence.startIndex]
        let newCost = Int(oldCost)! - removedPrice
        cost = String(newCost) + currency
        print(cost)
    }
    
}
