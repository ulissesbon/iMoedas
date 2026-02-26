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
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var valor: Float = 0
    
    var formValido: Bool {
           // Verifica se não está vazio e se não é apenas espaços
           !titulo.trimmingCharacters(in: .whitespaces).isEmpty &&
           !descricao.trimmingCharacters(in: .whitespaces).isEmpty
           && valor != 0
       }

    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 30) {
            TextField("Título", text: $titulo, axis: .vertical)
            TextField("Descrição", text: $descricao, axis: .vertical)
            TextField("Valor", value: $valor, format: .currency(code: "BRL"))
                .keyboardType(.decimalPad)
            
        }
        .padding()
        
        HStack(spacing: 50){
            Button("Cancelar") {
                dismiss()
            }
            .foregroundStyle(.red)
            Button("Salvar") {
                let newOperacao = Financas(valor: valor, titulo: titulo, descricao: descricao, categoria: "Teste", ganho: true)
                    operacoes.append(newOperacao)
                    dismiss()
            }
            .disabled(!formValido) // Desabilita o botão se formValido for false
        }

    }
}

struct ContentView: View {
    @State private var operacoes : [Financas] = [
        Financas(valor: 100, titulo: "Concurso de Dança", descricao: "1º lugar na categoria de bailar", categoria: "Lazer", ganho: true),
        Financas(valor: -50, titulo: "Almoço", descricao: "Mucei", categoria: "Alimentação", ganho: false)
    ]
    
    @State private var criarNovaOperacao = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                if operacoes.count != 0 {
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
                }
                else {
                    ContentUnavailableView("Sem histórico de operações. Clique no ícone + para começar.", systemImage: "brazilianrealsign.circle.fill")
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
