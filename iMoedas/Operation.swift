//
//  Financas.swift
//  iMoedas
//
//  Created by User on 02/03/26.
//
import SwiftUI
import SwiftData

@Model
class Operation {
    var title: String
    var value: Float
    var observation: String?
    var cashEntry: Bool = false
    var operationDate : Date
    
    init (
        title: String,
        value: Float,
        observation: String? = nil,
        cashEntry: Bool,
        operationDate: Date
    ) {
        self.title = title
        self.value = value
        self.observation = observation
        self.cashEntry = cashEntry
        self.operationDate = operationDate
    }
}

