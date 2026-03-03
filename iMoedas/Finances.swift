//
//  Financas.swift
//  iMoedas
//
//  Created by User on 02/03/26.
//
import SwiftUI
import SwiftData

//@Model
//class Financas {
//    let id = UUID()
//    var valor: Float
//    var titulo: String
//    var observacao: String
//    var categoria: String
//    var entrada: Bool = false
//    var data : Date
//    
//    init (
//        titulo: String,
//        valor: Float,
//        observacao: String? = nil,
//        categoria: String,
//        entrada: Bool,
//        data: Date
//    ) {
//        self.titulo = titulo
//        self.valor = valor
//        self.observacao = observacao
//        self.entrada = entrada
//        self.categoria = categoria
//        self.data = data
//    }
//}

struct Finances: Identifiable {
    let id = UUID()
    var valor: Float
    var titulo: String
    var observacao: String
    var categoria: String
    var entrada: Bool = false
    var data : Date
}
