//
//  ContentView.swift
//  Journali
//
//  Created by shatha on 29/05/1448 AH.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: JournalViewModel?

    var body: some View {
        Group {
            if let viewModel {
                HomeView(viewModel: viewModel)
            } else {
                SplashView()
            }
        }
        .task {
            if viewModel == nil {
                let newViewModel = JournalViewModel(
                    modelContext: modelContext
                )

                newViewModel.fetchJournals()
                viewModel = newViewModel
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self)
}
