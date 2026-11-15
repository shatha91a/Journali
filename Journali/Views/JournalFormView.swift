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
                        withAnimation(.easeOut(duration: 0.2)) {
                            showDiscardConfirmation = false
                        }
                    },
                    onDiscard: {
                        dismiss()
                    }
                )
                .transition(.opacity)
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
            withAnimation(.easeOut(duration: 0.2)) {
                showDiscardConfirmation = true
            }
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

    // MARK: - Design Dimensions
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 212
    private let cardRadius: CGFloat = 32

    private let cardLeading: CGFloat = 10
    private let cardTop: CGFloat = 10

    private let sidePadding: CGFloat = 16
    private let messageBlockHeight: CGFloat = 80
    private let messageInset: CGFloat = 9

    private let buttonHeight: CGFloat = 46
    private let buttonSpacing: CGFloat = 12

    var body: some View {
        ZStack(alignment: .topLeading) {

            // MARK: - Background
            Color.black.opacity(0.08)
                .ignoresSafeArea()
                .onTapGesture(perform: onKeepEditing)

            // MARK: - Glass Alert
            VStack(spacing: 0) {

                Text("Are you sure you want to discard changes on this journal?")
                    .font(AppFonts.captionMedium)
                    .lineSpacing(3)
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, messageInset)
                    .padding(.top, messageInset)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: messageBlockHeight,
                        maxHeight: messageBlockHeight,
                        alignment: .topLeading
                    )

                VStack(spacing: buttonSpacing) {

                    alertButton(
                        "Discard Changes",
                        color: AppColors.destructive,
                        action: onDiscard
                    )

                    alertButton(
                        "Keep Editing",
                        color: AppColors.primaryText,
                        action: onKeepEditing                    )
                }
            }
            .padding(.horizontal, sidePadding)
            .padding(.top, 14)
            .padding(.bottom, 14)
            .frame(
                width: cardWidth,
                height: cardHeight,
                alignment: .top
            )
            .glassEffect(
                .regular.tint(.black.opacity(0.57)),
                in: .rect(cornerRadius: cardRadius)
            )
            .padding(.leading, cardLeading)
            .padding(.top, cardTop)
        }
        .environment(\.colorScheme, .dark)
    }

    // MARK: - Glass Buttons
    private func alertButton(
        _ title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {
            Text(title)
                .font(AppFonts.captionMedium)
                .foregroundStyle(color)
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
                .glassEffect(
                    .regular.tint(.black.opacity(0.25)).interactive(),
                    in: .capsule
                )
        }
        .buttonStyle(.plain)
    }
}
// MARK: - Previews

#Preview("Discard Alert") {
    ZStack(alignment: .topLeading) {
        AppColors.surface
            .ignoresSafeArea()

        // Background Journal Content
        VStack(alignment: .leading, spacing: AppSpacing.medium) {

            HStack {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                    .frame(width: 40, height: 40)

                Spacer()

                Image(systemName: "checkmark")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.background)
                    .frame(width: 44, height: 44)
                    .background(AppColors.primary, in: Circle())
            }

            Text("Great Day")
                .font(AppFonts.headingLarge)
                .foregroundStyle(AppColors.primaryText)

            Text("12/11/2026")
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.secondaryText)

            Text("""
            Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Quisque volutpat mattis eros. Nullam malesuada erat ut turpis.
            Suspendisse urna nibh, viverra non, semper suscipit posuere.
            """)
                .font(AppFonts.bodyLarge)
                .foregroundStyle(AppColors.primaryText)

            Spacer()
        }
        .padding(AppSpacing.medium)

        // Discard Alert
        DiscardChangesAlert(
            onKeepEditing: {},
            onDiscard: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Journal Form") {
    JournalFormView(onSave: { _, _ in })
        .preferredColorScheme(.dark)
}
