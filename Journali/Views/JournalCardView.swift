
import SwiftUI

struct JournalCardView: View {

    // MARK: - Properties

    let journal: JournalEntry
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Title and Bookmark

            HStack {
                Text(journal.title)
                    .font(AppFonts.titleCard)
                    .foregroundStyle(AppColors.textAccent)

                Spacer()

                Button {
                    onBookmarkTap()
                } label: {
                    Image(
                        systemName: journal.isBookmarked
                            ? "bookmark.fill"
                            : "bookmark"
                    )
                    .font(.system(size: 18))
                    .foregroundStyle(AppColors.textAccent)
                }
                .buttonStyle(.plain)
            }

            // MARK: - Date

            Text(journal.createdAt.formatted(
                date: .numeric,
                time: .omitted
            ))
            .font(AppFonts.captionSmall)
            .foregroundStyle(AppColors.secondaryText)

            // MARK: - Journal Content

            Text(journal.content)
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.primaryText)
                .lineLimit(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.medium)
        .frame(
            maxWidth: .infinity,
            minHeight: 227,
            maxHeight: 227,
            alignment: .topLeading
        )
        .background(
            AppColors.surface,
            in: RoundedRectangle(cornerRadius: 30)
        )
    }
}
