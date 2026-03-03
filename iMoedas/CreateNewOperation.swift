//
//  CriarNovaOperacao.swift
//  iMoedas
//
//  Created by User on 02/03/26.
//

import SwiftUI

struct CreateNewOperation: View {
    @Binding var operacoes: [Finances]
    
    @Environment(\.dismiss) var dismiss
    @State private var cashEntry: Bool = false
    @State private var title: String = ""
    @State private var observation: String = ""
    @State private var valor: Float = 0
    @State private var data: Date = Date()
    
    //private let categorias: [String] = ["Alimentação", "Trabalho", "Lazer", "Transporte", "Outros"]
    

    
    var formValido: Bool {
        // Verifica se não está vazio e se não é apenas espaços
        !title.trimmingCharacters(in: .whitespaces).isEmpty
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
    
    @State var selected: String = "Saída"
    

    var body: some View {
        let entradaOptions = [ "Entrada", "Saída"]
        
        NavigationStack{
            List {
                
                VStack(alignment: .leading, spacing: 12) {
                
                    Section("Título") {
                        TextField("Ex: Compra de livros", text: $title, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .previewLayout(.sizeThatFits)
                    }
                   
                    
                    Section("Valor") {
                        TextField("Valor", value: $valor, format: .currency(code: "BRL"))
                            .keyboardType(.decimalPad)
                            .textFieldStyle(OutlinedTextFieldStyleIcon())
                            .previewLayout(.sizeThatFits)
                    }
                    Spacer()
                    
                    Picker("Selecione a operação",
                           selection: $selected){
                        ForEach(entradaOptions, id: \.self) {
                            Text($0)
                        }
                        
                    }
                    .pickerStyle(.menu)
                    .tint(Color(.gray))
                    
                    Spacer()
                    
                    
                    DatePicker(selection: $data, in: ...Date.now, displayedComponents: .date) {
                        Text("Selecione a Data")
                    }
                    Spacer()
                    
                    Section("Observações (opcional") {
                        TextField("Ex: Preciso encapar os livros", text: $observation, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .previewLayout(.sizeThatFits)
                    }
                    Spacer()
                    
                    
                }
                .navigationTitle("Adicionar Operacao")
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
                            
                            cashEntry = (selected == "Entrada") ? true : false
                            
                            let newOperacao = Finances(value: valor, title: title.trimmingCharacters(in: .whitespaces), observation: observation.trimmingCharacters(in: .whitespaces), category: "Teste", cashEntry: cashEntry, operationDate: data)
                            operacoes.append(newOperacao)
                            dismiss()
                        }
                        .disabled(!formValido)
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            
            
        }
    }
}
