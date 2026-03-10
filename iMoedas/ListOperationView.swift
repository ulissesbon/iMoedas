//
//  ListOperationView.swift
//  iMoedas
//
//  Created by sure on 10/03/26.
//


import SwiftUI
import SwiftData

//struct OperationsGroup: Identifiable {
//    let id = UUID()
//    let date: Date
//    let operations: [Operation]
//}

struct ListOperationView: View {
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
    
    
//    func groupedOperations() -> [OperationsGroup] {
//        let operationsByDay = Dictionary(grouping: operations, by: { Calendar.current.startOfDay(for: $0.operationDate)  })
//        return operationsByDay.map { (date, operations) in
//            OperationsGroup(date: date, operations: operations)
//        }
//    }
    
    func balanceCalc() -> Float {
        let balance: Float = operations.reduce(0) { $0 + ($1.cashEntry ? $1.value : -$1.value) }
        return balance
    }
    
    func entriesCalc() -> Float {
        let entries: Float = operations.reduce(0) { $0 + ($1.cashEntry ? $1.value : 0)}
        return entries
    }
    
    
    var body: some View {
        //        Text("\(dates)")
        NavigationStack {
        
            
            
            
            if !operations.isEmpty {
                List {
                    Section {
                        
                        HStack {
                            Text("Saldo")
                                .font(.title2.bold())
                                .padding()
                            
                            if balanceCalc() >= 0{
                                Text("R$\(balanceCalc(), specifier: "%.2f")")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color(red: 0/255, green: 137/255, blue: 50/255))
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                                
                            } else {
                                    Text("-R$\(balanceCalc() * -1, specifier: "%.2f")")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.red)
                                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                            }
                            Spacer()
                        }
                        
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Entradas")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                    .padding(1)
                                
                                Text("R$\(entriesCalc(), specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(Color(red: 0/255, green: 137/255, blue: 50/255))
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                            }
                            
                            Divider()
                                .padding()
                            VStack {
                                Text("Saídas")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                    .padding(1)
                                
                                Text(balanceCalc() - entriesCalc() == 0 ? "R$ 0,00" : "-R$\((balanceCalc() - entriesCalc()) * -1, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(Color.red)
                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                
                                    
                            }
                        }
                    }
//                    .listSectionSpacing(0)

                    
                    //Código da divisão/section por datas
//                    ForEach(groupedOperations()) { group in
//                        Section("dia: \(group.date.formatted())") {
//                            ForEach(group.operations) { <#Int#> in
//                                <#code#>
//                            }
//                        }
//                    }
                    
                    Section("Histórico") {
                        
                        ForEach(operations) { operation in
                            
                            NavigationLink {
                                OperationDetailView(operation: operation)
                            } label: {
                                VStack{
                                    Text("\(operation.title)")
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                    
                                    Text("\(operation.operationDate, formatter: dateFormatter)")
                                        .font(Font.subheadline.italic())
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                                }
                                
                                if operation.cashEntry == true {
                                    Text("R$\(operation.value, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 0/255, green: 137/255, blue: 50/255))
                                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                                    
                                }
                                // Mostra o valor em vermelho e com negativo antes
                                else {
                                    Text("-R$\(operation.value, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(Color.red)
                                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .trailing, vertical: .center))
                                    
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
//                    .listSectionSpacing(0)
                    .padding(4)
                }
                .listSectionSpacing(10)

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
                
                List {
                    ContentUnavailableView("Sem histórico de operações. Clique no ícone + para começar.", systemImage: "brazilianrealsign.circle.fill")
                }
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
            }
            
            
        }
//        .onAppear {
//            let groups = groupedOperations()
//            print(groups.count)
//        }
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
