
import SwiftUI

struct EmptyStateView: View {

    // MARK: - Body

    var body: some View {
        VStack(spacing: AppSpacing.medium) {

            // MARK: - Empty State Image

            Image("Empty")
                .resizable()
                .scaledToFit()
                .frame(width: 151.39, height: 97.32)

            // MARK: - Empty State Message

            Text("Begin Your Journal")
                .font(AppFonts.headingMedium)
                .foregroundStyle(AppColors.textAccent)

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(AppFonts.bodySupporting)
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        EmptyStateView()
    }
}
