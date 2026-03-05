//  ContentView.swift
//  iMoedas
//
//  Created by User on 24/02/26.
//

import SwiftUI
import SwiftData

struct OperationsGroup: Identifiable {
    let id = UUID()
    let date: Date
    let operations: [Operation]
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Operation.title) private var operations: [Operation]
    
    @State private var createOperationSheet = false
    @State private var editOperationSheet = false
    
    @State private var editingOperation: Operation? = nil
    
    let dateFormatter: DateFormatter = { //Formatação da data
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "br_BR")
        formatter.dateStyle = .medium
        return formatter
    }()
    
    //    let newOperation = Finances(title: "reste/", value: 88.99, cashEntry: true, operationDate: Date())
    //    modelContext.insert(newOperation)
    //
    //    var dates: [Date] {
    //        Set(operations.map(\.operationDate)).sorted()
    //    }
    
    
    func groupedOperations() -> [OperationsGroup] {
        let operationsByDay = Dictionary(grouping: operations, by: { Calendar.current.startOfDay(for: $0.operationDate)  })
        return operationsByDay.map { (date, operations) in
            OperationsGroup(date: date, operations: operations)
        }
    }
    
    var body: some View {
        //        Text("\(dates)")
        NavigationStack {
        
            
            
            
            if !operations.isEmpty {
                List {
//                    ForEach(groupedOperations()) { group in
//                        Section("dia: \(group.date.formatted())") {
////                            ForEach(group.operations) { <#Int#> in
////                                <#code#>
////                            }
//                        }
//                    }
                    ForEach(operations) { operation in
                        NavigationLink {
                            OperationDetailView(operation: operation)
                        } label: {
                            Text("\(operation.title)")
                                .bold()
                            
//                            if operation.observation != "" {
//                                Text("\(operation.observation)")
//                                    .font(.subheadline.italic().weight(.thin))
//                            }
                            
                            Text("\(operation.operationDate, formatter: dateFormatter)")
                                .font(Font.subheadline.italic())
                                .foregroundColor(Color.gray)
                            
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
                            
                        }
                        
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            let operation = operations[index]
                            modelContext.delete(operation)
                        }
                    }
                }
                .navigationTitle(Text("Saldo"))
                .toolbar {
                    Button {
                        createOperationSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $createOperationSheet) {
                    CreateNewOperation()
                }
            } else {
                ListEmptyView()
                //ContentUnavailableView("Sem histórico de operações. Clique no ícone + para começar.", systemImage: "brazilianrealsign.circle.fill")
            }
            
            //                            else {
            //                                ContentUnavailableView("Sem histórico de operações. Clique no ícone + para começar.", systemImage: "brazilianrealsign.circle.fill")
            //                            }
            
            
            
        }
        .onAppear {
            let groups = groupedOperations()
            print(groups.count)
        }
    }
}


#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Operation.self, configurations: configuration)
    
    var operationCollection: [Operation] = [
        Operation(
            title: "Almoço",
            value: 88.99,
            cashEntry: false,
            operationDate: .init()
        ),
        Operation(
            title: "Salario",
            value: 1250.00,
            observation: "Salario do mês",
            cashEntry: true,
            operationDate: .init()
        ),
        Operation(
            title: "Conserto carro",
            value: 500.99,
            cashEntry: false,
            operationDate: .init()
        ),
        Operation(
            title: "Freelancer",
            value: 3000,
            observation: "Desenvolvimento de site",
            cashEntry: true,
            operationDate: Date().addingTimeInterval(-86_400)
        ),
        Operation(
            title: "Salgado",
            value: 4.99,
            cashEntry: false,
            operationDate: Date().addingTimeInterval(2 * (-86_400))
        )
    ]
    
    for operation in operationCollection {
        container.mainContext.insert(operation)
    }
    
    
    return ContentView()
        .modelContainer(container)
    
    
}
