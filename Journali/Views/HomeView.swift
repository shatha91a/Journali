
import SwiftUI

struct HomeView: View {

    let viewModel: JournalViewModel

    @State private var showingAddJournal = false
    @State private var selectedJournal: JournalEntry?
    @State private var journalToDelete: JournalEntry?
    @State private var showDeleteConfirmation = false

    var body: some View {

        ZStack {

            AppColors.background
                .ignoresSafeArea()

            VStack {

                // MARK: - Header
                HStack {

                    Text("Journal")
                        .font(AppFonts.headingLarge)
                        .foregroundStyle(AppColors.primaryText)

                    Spacer()

                    HStack(spacing: 20) {

                        Menu {

                            Button {
                                viewModel.showBookmarkedOnly.toggle()
                            } label: {

                                Label(
                                    viewModel.showBookmarkedOnly
                                        ? "Show All Journals"
                                        : "Sort by Bookmark",
                                    systemImage: "bookmark"
                                )
                            }

                            Button {
                                viewModel.isNewestFirst.toggle()
                            } label: {

                                Label(
                                    viewModel.isNewestFirst
                                        ? "Oldest First"
                                        : "Newest First",
                                    systemImage: "calendar"
                                )
                            }

                        } label: {

                            Image(systemName: "line.3.horizontal.decrease")
                        }

                        Button {
                            showingAddJournal = true
                        } label: {

                            Image(systemName: "plus")
                        }
                    }
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppColors.surface, in: Capsule())
                }
                .padding(.horizontal, AppSpacing.medium)
                .padding(.top, AppSpacing.medium)

                // MARK: - Journal List
                if viewModel.filteredJournals.isEmpty {

                    Spacer()

                    EmptyStateView()
                        .frame(maxWidth: .infinity)

                    Spacer()

                } else {

                    ScrollView {

                        LazyVStack(spacing: AppSpacing.medium) {

                            ForEach(viewModel.filteredJournals) { journal in

                                JournalCardView(journal: journal) {

                                    viewModel.toggleBookmark(for: journal)
                                }
                                .onTapGesture {

                                    selectedJournal = journal
                                }
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: false
                                ) {

                                    Button(role: .destructive) {

                                        journalToDelete = journal
                                        showDeleteConfirmation = true

                                    } label: {

                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.medium)
                        .padding(.vertical, AppSpacing.medium)
                    }
                    .scrollDismissesKeyboard(.interactively)
                }

                // MARK: - Search Bar
                SearchBarView(viewModel: viewModel)
                    .padding(.horizontal, AppSpacing.medium)
                    .padding(.bottom, AppSpacing.medium)
            }

            // MARK: - Delete Confirmation
            if showDeleteConfirmation {

                DeleteConfirmationView {

                    // Cancel
                    showDeleteConfirmation = false
                    journalToDelete = nil

                } onDelete: {

                    // Delete
                    if let journal = journalToDelete {

                        viewModel.deleteJournal(journal)
                    }

                    showDeleteConfirmation = false
                    journalToDelete = nil
                }
                .zIndex(1)
            }
        }

        // MARK: - Add Journal Sheet
        .sheet(isPresented: $showingAddJournal) {

            JournalFormView { title, content in

                viewModel.addJournal(
                    title: title,
                    content: content
                )
            }
        }

        // MARK: - Edit Journal Sheet
        .sheet(item: $selectedJournal) { journal in

            JournalFormView(journal: journal) { title, content in

                viewModel.editJournal(
                    journal,
                    title: title,
                    content: content
                )
            }
        }
    }
}
