//
//  teste.swift
//  iMoedas
//
//  Created by Sure & Ulisses on 03/03/26.
//

import SwiftUI
import Playgrounds
import SwiftData

#Playground ("Usando Struct") {
    struct Item {
        var name: String
    }
    
    var item1 = Item(name: "Apple")
    var item2 = item1
    item2.name = "Banana"
    
    print("Item 1: \(item1.name) \nItem 2: \(item2.name)")
    
}

#Playground ("Usando class") {
    class Item {
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    var item1 = Item(name: "Apple")
    var item2 = item1
    item2.name = "Banana"
    
    print("Item 1: \(item1.name) \nItem 2: \(item2.name)")
}
