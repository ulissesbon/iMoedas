//
//  ListEmptyView.swift
//  iMoedas
//
//  Created by User on 04/03/26.
//

import SwiftUI
import SwiftData

struct ListEmptyView: View {
    @State private var createOperationSheet = false
    
    var body: some View {
        VStack {
            Text("Sem histórico de operações")
                .font(Font.system(size: 28, weight: .semibold))
            
            Text("Clique no botão abaixo para começar.")
                .font(Font.system(size: 16, weight: .regular))
                .foregroundColor(Color(.secondaryLabel))

            
            Button (action: {
                createOperationSheet = true
                CreateNewOperation()
            }) {
                Text("Criar operação")
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ListEmptyView()
}
