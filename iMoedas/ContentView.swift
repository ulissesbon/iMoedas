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
    var observacao: String
    var categoria: String
    var entrada: Bool = false
    //    var data : Date
}

struct CriarNovaOperacao: View {
    @Binding var operacoes: [Financas]
    
    @Environment(\.dismiss) var dismiss
    @State private var entrada: Bool = false
    @State private var titulo: String = ""
    @State private var observacao: String = ""
    @State private var valor: Float = 0
    @State private var data: Date = Date()
    
    //private let categorias: [String] = ["Alimentação", "Trabalho", "Lazer", "Transporte", "Outros"]
    
    
    
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
    
    @State var selected: String = ""
    

    var body: some View {
        let entradaOptions = [ "Entrada", "Saída"]
        
        NavigationStack{
            VStack(spacing: 24) {
                TextField("Título", text: $titulo, axis: .vertical)
                    .textFieldStyle(OutlinedTextFieldStyle())
                    .previewLayout(.sizeThatFits)
                
                
                TextField("Valor", value: $valor, format: .currency(code: "BRL"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(OutlinedTextFieldStyleIcon())
                    .previewLayout(.sizeThatFits)
                
                Picker("",
                       selection: $selected,
                       content: {
                    ForEach(entradaOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                ).pickerStyle(.segmented)

                
                TextField("Observações (Opcional)", text: $observacao, axis: .vertical)
                    .textFieldStyle(OutlinedTextFieldStyle())
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
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        
                        entrada = (selected == "Entrada") ? true : false
                        valor = (entrada == true) ? valor : -valor
                        
                        let newOperacao = Financas(valor: valor, titulo: titulo.trimmingCharacters(in: .whitespaces), observacao: observacao.trimmingCharacters(in: .whitespaces), categoria: "Teste", entrada: entrada)
                        operacoes.append(newOperacao)
                        dismiss()
                    }
                    .disabled(!formValido)
                }
            }
            
        }
    }
}

struct EditarOperacao: View {
    @Binding var operacoes: [Financas]
    
    @Environment(\.dismiss) var dismiss
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var valor: Float = 0
    
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
        NavigationStack {
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
            .navigationTitle("Editar Transação")
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
                        let newOperacao = Financas(valor: valor, titulo: titulo.trimmingCharacters(in: .whitespaces), observacao: descricao.trimmingCharacters(in: .whitespaces), categoria: "Teste", entrada: true)
                        operacoes.append(newOperacao)
                        dismiss()
                    }
                }
            }
            
        }
    }
}

struct ContentView: View {
    @State private var operacoes : [Financas] = [
        Financas(valor: 100, titulo: "Concurso de Dança", observacao: "1º lugar na categoria de bailar", categoria: "Lazer", entrada: true),
        Financas(valor: -50, titulo: "Almoço", observacao: "Mucei", categoria: "Alimentação", entrada: false)
    ]
    
    @State private var criarNovaOperacao = false
    @State private var editSheet = false
    
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
                                        .foregroundColor(operacao.entrada ? Color.green : Color.red)
                                } label: {
                                    Text("\(operacao.titulo)")
                                    
                                }
                                Text("\(operacao.observacao)")
                                    .font(.subheadline)
                            }
                            .swipeActions(edge: .trailing) {
                                deleteAction(operacao.id)
                                editAction(operacao.id)
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
            .sheet(isPresented: $editSheet) {
                EditarOperacao(operacoes: $operacoes)
            }
        }
        
    }
    private func deleteAction(_ operacaoId: Financas.ID) -> some View {
        Button(role: .destructive) {
            operacoes.removeAll(where: {$0.id == operacaoId})
        } label: {
            VStack {
                Image(systemName: "trash.fill")
                Text("Excluir")
            }
        }
        
    }
    private func editAction(_ operacaoId: Financas.ID) -> some View {
        Button {
            editSheet = true
        } label: {
            VStack {
                Image(systemName: "pencil")
                Text("Editar")
            }
        }
        .tint(Color(red: 255/255, green: 128/255, blue: 0/255))
    }
}



#Preview {
    ContentView()
    
}
