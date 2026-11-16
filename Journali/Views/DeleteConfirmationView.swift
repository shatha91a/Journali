
import SwiftUI

struct DeleteConfirmationView: View {

    // MARK: - Properties

    let onCancel: () -> Void
    let onDelete: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            // MARK: - Background

            Color.black.opacity(0.65)
                .ignoresSafeArea()

            // MARK: - Confirmation Alert

            VStack(alignment: .leading, spacing: 12) {
                Text("Delete Journal?")
                    .font(AppFonts.captionMedium)
                    .foregroundStyle(AppColors.primaryText)

                Text("Are you sure you want to delete this journal?")
                    .font(AppFonts.captionSmall)
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                // MARK: - Alert Actions

                HStack(spacing: 8) {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(AppFonts.captionMedium)
                            .foregroundStyle(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                Color(hex: 0x303034),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)

                    Button(action: onDelete) {
                        Text("Delete")
                            .font(AppFonts.captionMedium)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                AppColors.destructive,
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(width: 270)
            .glassEffect(
                .regular.tint(AppColors.surface.opacity(0.9)),
                in: .rect(cornerRadius: 24)
            )
        }
    }
}
