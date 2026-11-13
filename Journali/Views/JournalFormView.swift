
import SwiftUI

struct JournalFormView: View {

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - Properties
    let journal: JournalEntry?
    let onSave: (String, String) -> Void

    // MARK: - State
    @State private var title: String
    @State private var content: String
    @State private var showDiscardConfirmation = false

    // MARK: - Initializer
    init(
        journal: JournalEntry? = nil,
        onSave: @escaping (String, String) -> Void
    ) {
        self.journal = journal
        self.onSave = onSave
        _title = State(initialValue: journal?.title ?? "")
        _content = State(initialValue: journal?.content ?? "")
    }

    // MARK: - Computed Properties
    private var hasUnsavedChanges: Bool {
        guard let journal else {
            return !title.isEmpty || !content.isEmpty
        }

        return title != journal.title ||
               content != journal.content
    }

    private var isSaveDisabled: Bool {
        title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            AppColors.surface
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppSpacing.medium) {

                // MARK: - Top Bar
                topBar

                // MARK: - Title
                TextField("Title", text: $title)
                    .font(AppFonts.headingLarge)
                    .foregroundStyle(AppColors.primaryText)

                // MARK: - Date
                Text(
                    (journal?.createdAt ?? Date.now).formatted(
                        .dateTime
                            .day(.twoDigits)
                            .month(.twoDigits)
                            .year()
                    )
                )
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.secondaryText)

                // MARK: - Journal Content
                TextEditor(text: $content)
                    .font(AppFonts.bodyLarge)
                    .foregroundStyle(AppColors.primaryText)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer(minLength: 0)
            }
            .padding(AppSpacing.medium)

            // MARK: - Discard Confirmation
            if showDiscardConfirmation {
                DiscardChangesAlert(
                    onKeepEditing: {
                        showDiscardConfirmation = false
                    },
                    onDiscard: {
                        showDiscardConfirmation = false
                        dismiss()
                    }
                )
                .zIndex(1)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(AppColors.surface)
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button {
                handleClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                    .frame(width: 40, height: 40)
                    .background(AppColors.surface, in: Circle())
            }

            Spacer()

            Button {
                saveJournal()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.background)
                    .frame(width: 44, height: 44)
                    .background(AppColors.primary, in: Circle())
            }
            .disabled(isSaveDisabled)
        }
    }

    // MARK: - Handle Close
    private func handleClose() {
        if hasUnsavedChanges {
            showDiscardConfirmation = true
        } else {
            dismiss()
        }
    }

    // MARK: - Save Journal
    private func saveJournal() {
        guard !isSaveDisabled else { return }

        onSave(title, content)
        dismiss()
    }
}

// MARK: - Discard Changes Alert


private struct DiscardChangesAlert: View {

    let onKeepEditing: () -> Void
    let onDiscard: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {

            // MARK: - Background
            Color.black.opacity(0.08)
                .ignoresSafeArea()

            // MARK: - Glass Alert
            VStack(alignment: .leading, spacing: 12) {

                Text("Are you sure you want to discard changes on this journal?")
                    .font(AppFonts.captionSmall)
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                // MARK: - Discard Button
                Button(action: onDiscard) {
                    Text("Discard Changes")
                        .font(AppFonts.captionSmall)
                        .foregroundStyle(AppColors.destructive)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay {
                                    Capsule()
                                        .fill(Color.white.opacity(0.13))
                                }
                        }
                }

                // MARK: - Keep Editing Button
                Button(action: onKeepEditing) {
                    Text("Keep Editing")
                        .font(AppFonts.captionSmall)
                        .foregroundStyle(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay {
                                    Capsule()
                                        .fill(Color.white.opacity(0.13))
                                }
                        }
                }
            }
            .padding(14)
            .frame(width: 310)
            .background {
                RoundedRectangle(cornerRadius: 26)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color(hex: 0x1C1C1E).opacity(0.18))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(
                                Color.white.opacity(0.16),
                                lineWidth: 1
                            )
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .environment(\.colorScheme, .dark)
            .padding(.leading, 16)
            .padding(.top, 8)
        }
        .environment(\.colorScheme, .dark)
    }
}
