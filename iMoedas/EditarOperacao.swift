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
                ToolbarItem(placement: .confirmationAction){
                    
                    Button(role: .confirm) {
                        let newOperacao = Financas(valor: valor, titulo: titulo.trimmingCharacters(in: .whitespaces), observacao: descricao.trimmingCharacters(in: .whitespaces), categoria: "Teste", entrada: true, data: Date())
                        operacoes.append(newOperacao)
                        dismiss()
                    }
                }
            }
            
        }
    }
}