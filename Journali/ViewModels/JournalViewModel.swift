
import SwiftData
import Observation
import Foundation

@MainActor
@Observable
final class JournalViewModel {

    // MARK: - Properties

    private(set) var journals: [JournalEntry] = []
    private let modelContext: ModelContext

    var searchText = ""
    var isNewestFirst = true
    var showBookmarkedOnly = false
    var sortByBookmark = false

    // MARK: - Filtered & Sorted Journals

    var filteredJournals: [JournalEntry] {

        let results = journals.filter { journal in

            let matchesSearch =
                searchText.isEmpty ||
                journal.title.localizedCaseInsensitiveContains(searchText) ||
                journal.content.localizedCaseInsensitiveContains(searchText)

            let matchesBookmark =
                !showBookmarkedOnly || journal.isBookmarked

            return matchesSearch && matchesBookmark
        }

        return results.sorted { first, second in

            // Sort bookmarked journals first only when enabled
            if sortByBookmark &&
                first.isBookmarked != second.isBookmarked {
                return first.isBookmarked
            }

            // Sort by date
            if isNewestFirst {
                return first.createdAt > second.createdAt
            } else {
                return first.createdAt < second.createdAt
            }
        }
    }

    // MARK: - Initializer

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Fetch Journals

    func fetchJournals() {
        do {
            let descriptor = FetchDescriptor<JournalEntry>()
            journals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch journals: \(error)")
        }
    }

    // MARK: - Add Journal

    func addJournal(title: String, content: String) {
        let newJournal = JournalEntry(
            title: title,
            content: content
        )

        modelContext.insert(newJournal)

        do {
            try modelContext.save()
            fetchJournals()
        } catch {
            print("Failed to save journal: \(error)")
        }
    }

    // MARK: - Edit Journal

    func editJournal(
        _ journal: JournalEntry,
        title: String,
        content: String
    ) {
        journal.title = title
        journal.content = content

        do {
            try modelContext.save()
            fetchJournals()
        } catch {
            print("Failed to update journal: \(error)")
        }
    }

    // MARK: - Delete Journal

    func deleteJournal(_ journal: JournalEntry) {
        modelContext.delete(journal)

        do {
            try modelContext.save()
            fetchJournals()
        } catch {
            print("Failed to delete journal: \(error)")
        }
    }

    // MARK: - Toggle Bookmark

    func toggleBookmark(for journal: JournalEntry) {
        journal.isBookmarked.toggle()

        do {
            try modelContext.save()
        } catch {
            print("Failed to update bookmark: \(error)")
        }
    }
}
