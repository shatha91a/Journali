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

                // Wait for 2 seconds
                try? await Task.sleep(nanoseconds: 2_000_000_000)

                viewModel = newViewModel
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self)
}
