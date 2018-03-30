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
    var currentDrink: a = .frappe
    enum a: String {
        case frappe = "frappe"
        case latte = "latte"
    }
    var currentDrinkIndex = 0
    var backgroundDrinkIndex = 1
    
    mutating func switchDrinks () {
        currentDrinkIndex = currentDrinkIndex + backgroundDrinkIndex
        backgroundDrinkIndex = currentDrinkIndex - backgroundDrinkIndex
        currentDrinkIndex = currentDrinkIndex - backgroundDrinkIndex
        switch currentDrink {
            case .frappe : currentDrink = .latte
            case .latte :currentDrink = .frappe
        }
        
    }
    
}
