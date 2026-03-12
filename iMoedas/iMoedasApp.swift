//
//  iMoedasApp.swift
//  iMoedas
//
//  Created by Sure & Ulisses on 24/02/26.
//

import SwiftUI
import SwiftData

@main
struct iMoedasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Operation.self])
    }
}
