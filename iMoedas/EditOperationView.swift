//
//  CriarNovaOperacao.swift
//  iMoedas
//
//  Created by User on 02/03/26.
//

import SwiftUI
import SwiftData

struct EditOperationView: View {

    @Environment(\.dismiss) private var dismiss
    var operation: Finances
    
    @State private var cashEntry: Bool = false
    @State private var title: String = ""
    @State private var observation: String = ""
    @State private var value: Float = 0
    @State private var operationDate: Date = Date()
    
    var validForm: Bool {
        // Verifica se não está vazio e se não é apenas espaços.
        
        //&& !observacao.trimmingCharacters(in: .whitespaces).isEmpty
        let first = !title.trimmingCharacters(in: .whitespaces).isEmpty
        print("!titulo.trimmingCharacters(in: .whitespaces).isEmpty : \(first)")
        
        let second = value != 0
        print("valor != 0 : \(second)")
        
        let third = title != editingOperation.title || value != editingOperation.value || cashEntry != editingOperation.cashEntry || operationDate != editingOperation.operationDate || observation != editingOperation.observation
        print("Edição: \(third)")
        
        print("Resultado: \(first && second && third)")
        
        //Não pode salvar as alterações, caso não tenha feito alteração
        return !title.trimmingCharacters(in: .whitespaces).isEmpty
        && value != 0
        && (title != editingOperation.title
        || value != editingOperation.value
        || cashEntry != editingOperation.cashEntry
        || operationDate != editingOperation.operationDate
        || observation != editingOperation.observation)
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
                    
                    
                    Picker("Selecione a operação",
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
                    
                    Section("Observações") {
                        TextField("Observações (Opcional)", text: $observation, axis: .vertical)
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
                    
                    ToolbarItem(placement: .cancellationAction){
                        Button(role: .close) {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) {
                            
                            cashEntry = (selected == "Entrada") ? true : false
                            
                            if let indice = operations.firstIndex(where: { $0.id == editingOperation.id }){
                                operations[indice].title = title.trimmingCharacters(in: .whitespaces)
                                operations[indice].observation = observation
                                operations[indice].value = value
                                operations[indice].cashEntry = cashEntry
                                operations[indice].operationDate = operationDate
                            }
                            dismiss()
                        }
                        .disabled(!validForm) // TODO: logica para desabilitar
                    }
                }
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            .onAppear {
                title = editingOperation.title
                value = editingOperation.value
                value = (value < 0) ? -value : value
                cashEntry = editingOperation.cashEntry
                observation = editingOperation.observation
                operationDate = editingOperation.operationDate
                selected = (editingOperation.cashEntry == true) ? "Entrada" : "Saída"
            }
            
            
        }
    }
    
}


#Preview {
    @Previewable @State var operations: [Finances] = []
    let editingOperation: Finances = .init(
        value: 111,
        title: "A",
        observation: "B",
        category: "C",
        cashEntry: true,
        operationDate: .init()
    )
    EditOperationView(operations: $operations, editingOperation: editingOperation)
}
