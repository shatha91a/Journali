//
//  JournaliApp.swift
//  Journali
//
//  Created by shatha on 29/05/1448 AH.
//


import SwiftUI
import SwiftData

@main
struct JournaliApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: JournalEntry.self)
    }
}
