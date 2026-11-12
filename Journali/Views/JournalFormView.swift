
import SwiftUI

struct JournalFormView: View {

    @Environment(\.dismiss) private var dismiss

    // MARK: - Properties
    let journal: JournalEntry?
    let onSave: (String, String) -> Void

    @State private var title: String
    @State private var content: String

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

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {

            // MARK: - Top Bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppColors.primaryText)
                        .frame(width: 40, height: 40)
                        .background(AppColors.surface, in: Circle())
                }

                Spacer()

                Button {
                    onSave(title, content)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppColors.background)
                        .frame(width: 44, height: 44)
                        .background(AppColors.primary, in: Circle())
                }
                .disabled(
                    title.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }

            // MARK: - Title
            TextField("Title", text: $title)
                .font(AppFonts.headingLarge)
                .foregroundStyle(AppColors.primaryText)

            // MARK: - Date
            Text((journal?.createdAt ?? Date.now).formatted(
                .dateTime.day(.twoDigits)
                    .month(.twoDigits)
                    .year()
            ))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.surface)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(AppColors.surface)
    }
}
