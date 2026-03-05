//
//  OperationDetailView.swift
//  iMoedas
//
//  Created by User on 04/03/26.
//
import SwiftData
import SwiftUI

struct OperationDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var operation: Operation
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingEditSheet: Bool = false
    
    @State private var deleteConfirmation: Bool = false
    
    var body: some View {
        List {
            LabeledContent("Título", value: operation.title)
            
            HStack{
                Text("Valor")
                if operation.cashEntry == true {
                    Text("R$\(operation.value, specifier: "%.2f")")
                        .bold()
                        .foregroundColor(Color(red: 0/255, green: 137/255, blue: 50/255))
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                }
                else if operation.cashEntry == false {
                    Text("-R$\(operation.value, specifier: "%.2f")")
                        .bold()
                        .foregroundColor(Color.red)
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                }
                
            }
            HStack {
                Text("Tipo")
                if operation.cashEntry == true {
                    Text("Entrada")
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                }
                else if operation.cashEntry == false {
                    Text("Saída")
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                }
                
            }
            HStack{
                Text("Data")
                Text("\(operation.operationDate, style: .date)")
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
            }
            
            LabeledContent("Observação", value: "\(operation.observation ?? "-")")
            
        }
        .navigationTitle(operation.title)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                isShowingEditSheet = true
            } label: {
                Image(systemName: "pencil")
                Text("Editar")
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            EditOperationView(operation: operation)
        }
        
        Button {
            deleteConfirmation = true
        } label: {
            Image(systemName: "trash")
            Text("Excluir")
        }
        .confirmationDialog("Deletar", isPresented: $deleteConfirmation) {
            Button("Excluir", role: .destructive) {
                modelContext.delete(operation)
                dismiss()
            }
        } message: {
            Text("Deletar operação?")
        }
    }
}

#Preview {
    @Previewable var operation = Operation(
        title: "Teste",
        value: 88.99,
        cashEntry: true,
        operationDate: .init()
    )
    NavigationStack {
        OperationDetailView(operation: operation)
    }
}
