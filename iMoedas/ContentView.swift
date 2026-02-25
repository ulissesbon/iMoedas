//  ContentView.swift
//  iMoedas
//
//  Created by User on 24/02/26.
//

import SwiftUI

struct Financas: Identifiable {
    let id = UUID()
    var valor: Float
    var titulo: String
    var descricao: String
    var categoria: String
    var ganho: Bool = false
}

struct CriarNovaOperacao: View {
    @Binding var operacoes: [Financas]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Adicionar teste") {
            operacoes.append(Financas(valor: 100, titulo: "Concurso de Dança", descricao: "1º lugar na categoria de bailar", categoria: "Lazer", ganho: true))
            dismiss()
        }
    }
}

struct ContentView: View {
    @State private var operacoes = [
        Financas(valor: 100, titulo: "Concurso de Dança", descricao: "1º lugar na categoria de bailar", categoria: "Lazer", ganho: true),
        Financas(valor: -50, titulo: "Almoço", descricao: "Mucei", categoria: "Alimentação", ganho: false)
    ]
    
    @State private var criarNovaOperacao = false
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(operacoes) { operacao in
                    
                    VStack(alignment: .leading){
                        LabeledContent {
                            Text("\(operacao.valor, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(operacao.ganho ? Color.green : Color.red)
                        } label: {
                            Text("\(operacao.titulo)")
                            
                        }
                        Text("\(operacao.descricao)")
                            .font(.subheadline)
                    }
                    
                }
            }
            .navigationTitle(Text("iMoedas"))
            .toolbar {
                    Button {
                      criarNovaOperacao = true
                    } label: {
                      Image(systemName: "plus.circle.fill")
                    }
                  }
                  .sheet(isPresented: $criarNovaOperacao) {
                    CriarNovaOperacao(operacoes: $operacoes)
                  }
        }
        
    }
}



#Preview {
    ContentView()
}
