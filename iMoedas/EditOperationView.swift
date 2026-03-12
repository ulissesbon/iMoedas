//
//  CriarNovaOperacao.swift
//  iMoedas
//
//  Created by Sure & Ulisses on 02/03/26.
//

import SwiftUI
import SwiftData

struct EditOperationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var operation: Operation
    
    @State private var cashEntry: Bool = false
    @State private var title: String = ""
    @State private var observation: String = ""
    @State private var value: Float = 0
    @State private var operationDate: Date = Date()
    
    @State private var discardChanges = false
    @State private var saveChanges = false
    
//    private func validFormFunc() -> Bool {
//        cashEntry = (selected == "Entrada") ? true : false
//        
//        var validForm: Bool {
//            // Verifica se não está vazio e se não é apenas espaços.
//            
//            //&& !observacao.trimmingCharacters(in: .whitespaces).isEmpty
//            !title.trimmingCharacters(in: .whitespaces).isEmpty
//            && value != 0
//            
//            //Não pode salvar as alterações, caso não tenha feito alteração
//            && (
//                title != operation.title ||
//                value != operation.value ||
//                cashEntry != operation.cashEntry ||
//                operationDate != operation.operationDate ||
//                observation != operation.observation
//            )
//        }
//        return validForm
//    }
    
    
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
                           selection: $selected ){
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
                    
                    Section("Observações (Opcional)") {
                        TextField("Ex: Preciso encapar os livros", text: $observation, axis: .vertical)
                            .textFieldStyle(OutlinedTextFieldStyle())
                            .previewLayout(.sizeThatFits)
                    }
                    Spacer()
                    
                    
                }
                .navigationTitle("Editar Operação")
                .navigationBarTitleDisplayMode(.inline)
                .autocorrectionDisabled(true)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            if !title.isEmpty || value == 0.0{
                                discardChanges = true
                            } else {
                                dismiss()
                            }
                        }
                        .confirmationDialog("Descartar alterações", isPresented: $discardChanges) {
                            Button("Descartar", role: .destructive) {
                                dismiss()
                            }
                        } message: {
                            Text("Descartar alterações?")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) {
                            saveChanges = true
                            
                        }
                        .confirmationDialog("Salvar alterações", isPresented: $saveChanges) {
                            Button("Salvar", role: .confirm) {
                                save()
                                dismiss()
                            }
                        } message: {
                            Text("Salvar alterações?")
                        }
                       // .disabled(!(!title.trimmingCharacters(in: .whitespaces).isEmpty && value != 0))
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            .onAppear {
                title = operation.title
                value = operation.value
                value = operation.value
                cashEntry = operation.cashEntry
                observation = operation.observation ?? ""
                operationDate = operation.operationDate
                selected = (operation.cashEntry == true) ? "Entrada" : "Saída"
            }
            
            
        }
    }
    
    private func save() {
        operation.title = title
        operation.value = value
        cashEntry = (selected == "Entrada") ? true : false
        operation.cashEntry = cashEntry
        operation.operationDate = operationDate
        operation.observation = observation.isEmpty ? nil : observation
    }
    
}




#Preview {
    EditOperationView(
        operation: Operation(
            title: "Teste",
            value: 88.99,
            cashEntry: true,
            operationDate: .init()
        )
    )
}
