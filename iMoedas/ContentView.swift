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
           !titulo.trimmingCharacters(in: .whitespaces).isEmpty
           && valor != 0
       }
    
    struct OutlinedTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                }
        }
    }
    
    struct OutlinedTextFieldStyleIcon: TextFieldStyle {
        
        @State var icon: Image?
        
        func _body(configuration: TextField<Self._Label>) -> some View {
            HStack {
                if icon != nil {
                    icon
                        .foregroundColor(Color(UIColor.systemGray4))
                }
                configuration
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 24) {
                TextField("Título", text: $titulo, axis: .vertical)
                    .textFieldStyle(OutlinedTextFieldStyle())
                    .previewLayout(.sizeThatFits)
                    
                
                TextField("Descrição", text: $descricao, axis: .vertical)
                    .textFieldStyle(OutlinedTextFieldStyle())
                    .previewLayout(.sizeThatFits)
                    
                
                TextField("Valor", value: $valor, format: .currency(code: "BRL"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(OutlinedTextFieldStyleIcon())
                    .previewLayout(.sizeThatFits)
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("Adicionar Transação")
            .navigationBarTitleDisplayMode(.inline)
            .autocorrectionDisabled(true)
            .padding()
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction){
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    
                    Button(role: .confirm) {
                        let newOperacao = Financas(valor: valor, titulo: titulo.trimmingCharacters(in: .whitespaces), descricao: descricao.trimmingCharacters(in: .whitespaces), categoria: "Teste", ganho: true)
                            operacoes.append(newOperacao)
                            dismiss()
                    }
                    .disabled(!formValido)
                }
            }

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
