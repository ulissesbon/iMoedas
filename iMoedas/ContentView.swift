//  ContentView.swift
//  iMoedas
//
//  Created by User on 24/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var operations : [Finances] = [
        Finances(value: 100, title: "Concurso de Dança", observation: "1º lugar na categoria de bailar", category: "Lazer", cashEntry: true, operationDate: Date()),
        Finances(value: 50, title: "Almoço", observation: "Almoço no restaurante favorito", category: "Alimentação", cashEntry: false, operationDate: Date())
    ]
    
    @State private var createOperationSheet = false
    @State private var editOperationSheet = true
    
    @State private var editingOperation: Finances? = nil
    
    let dateFormatter: DateFormatter = { //Formatação da data
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "br_BR")
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
//    var dates: [Date] {
//        Set(operations.map(\.operationDate)).sorted()
//    }
    
    var body: some View {
//        Text("\(dates)")
        NavigationStack {
            ZStack{
                
                if operations.count != 0 {
                    List {
                        
                        ForEach(operations) { operation in
                            
                            VStack(alignment: .leading, spacing: 6){
                                
                                LabeledContent {
                                    // Mostra o valor em verde se for entrada
                                    if operation.cashEntry == true {
                                        Text("R$\(operation.value, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(Color(red: 0/255, green: 137/255, blue: 50/255))
                                        
                                    }
                                    // Mostra o valor em vermelho e com negativo antes
                                    else {
                                        Text("-R$\(operation.value, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(Color.red)
                                        
                                    }
                                } label: {
                                    Text("\(operation.title)")
                                        .bold()
                                    
                                }
                                Text("\(operation.observation)")
                                    .font(.subheadline.italic().weight(.thin))
                                
                                Text("\(operation.operationDate, formatter: dateFormatter)")
                                    .font(Font.subheadline.italic())
                                    .foregroundColor(Color.gray)
                                
                            }
                            .swipeActions(edge: .trailing) {
                                deleteAction(operation.id)
                                editAction(operation)
                            }
                            
                        }
                    }
                }
                else {
                    ContentUnavailableView("Sem histórico de operações. Clique no ícone + para começar.", systemImage: "brazilianrealsign.circle.fill")
                }
            }
            .navigationTitle(Text("Histórico"))
            .toolbar {
                Button {
                    createOperationSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(isPresented: $createOperationSheet) {
                CreateNewOperation(operations: $operations)
            }
            .sheet(item: $editingOperation) { operation in
                EditarOperacao(operations: $operations, editingOperation: operation)
            }
        }
        
    }
    private func deleteAction(_ operationId: Finances.ID) -> some View {
        Button(role: .destructive) {
            operations.removeAll(where: {$0.id == operationId})
        } label: {
            VStack {
                Image(systemName: "trash.fill")
                Text("Excluir")
            }
        }
        
    }
    private func editAction(_ operation: Finances) -> some View {
        Button {
            editingOperation = operation
            //            editSheet = true
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
