struct Financas: Identifiable {
    let id = UUID()
    var valor: Float
    var titulo: String
    var observacao: String
    var categoria: String
    var entrada: Bool = false
    var data : Date
}