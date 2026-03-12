//
//  CriarNovaOperacao.swift
//  iMoedas
//
//  Created by Sure & Ulisses on 02/03/26.
//

import SwiftUI
import SwiftData

struct CreateNewOperation: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var operationDate: Date = Date()
    @State private var observation: String = ""
    @State private var cashEntry: Bool = false
    @State private var title: String = ""
    @State private var value: Float = 0
    @State var selected: String = "Saída"
    
    var validForm: Bool {
        // Verifica se não está vazio e se não é apenas espaços
        !title.trimmingCharacters(in: .whitespaces).isEmpty
        && value != 0
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
        let entryOptions = [ "Entrada", "Saída"]
        
        NavigationStack{
            List {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Section("Título") {
                        TextField("Ex: Compra de livros", text: $title, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .previewLayout(.sizeThatFits)
                    }
                    
                    Section("Valor") {
                        TextField("Valor", value: $value, format: .currency(code: "BRL"))
                            .keyboardType(.decimalPad)
                            .textFieldStyle(OutlinedTextFieldStyleIcon())
                            .previewLayout(.sizeThatFits)
                    }
                    
                    Spacer()
                    
                    Picker("Selecione o tipo",
                           selection: $selected){
                        ForEach(entryOptions, id: \.self) {
                            Text($0)
                        }
                        
                    }
                           .pickerStyle(.menu)
                           .tint(Color(.gray))
                    
                    Spacer()
                    
                    DatePicker(selection: $operationDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Selecione a Data")
                    }
                    
                    Spacer()
                    
                    Section("Observações (opcional)") {
                        TextField("Ex: Preciso encapar os livros", text: $observation, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .previewLayout(.sizeThatFits)
                    }
                    
                    Spacer()
                    
                }
                .navigationTitle("Adicionar Operação")
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
                            
                            let newOperation = Operation(
                                title: title.trimmingCharacters(in: .whitespaces),
                                value: value,
                                observation: observation.trimmingCharacters(in: .whitespaces),
                                cashEntry: cashEntry,
                                operationDate: operationDate
                            )
                            modelContext.insert(newOperation)
                            dismiss()
                        }
                        .disabled(!validForm)
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    CreateNewOperation()
}
