
import SwiftUI
import SwiftData

struct ContentView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: JournalViewModel?

    // MARK: - Body

    var body: some View {
        Group {
            if let viewModel {
                HomeView(viewModel: viewModel)
            } else {
                SplashView()
            }
        }
        .task {
            // Initialize the ViewModel and load saved journals.
            if viewModel == nil {
                let newViewModel = JournalViewModel(
                    modelContext: modelContext
                )

                newViewModel.fetchJournals()

                // Keep the splash screen visible for 2 seconds.
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
