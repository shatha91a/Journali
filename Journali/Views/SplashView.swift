
import SwiftUI

struct SplashView: View {

    var body: some View {

        ZStack {

            // MARK: - Background
  
            LinearGradient(
                colors: [
                    Color(hex: 0x000000),
                    Color(hex: 0x0B0B12),
                    Color(hex: 0x151517)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MARK: - Splash Content

            VStack(spacing: 0) {

                Image("SplashImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 81.46, height: 106)

                Text("Journali")
                    .font(AppFonts.display)
                    .foregroundStyle(AppColors.primaryText)
                    .padding(.top, 21)

                Text("Your thoughts, your story")
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.secondaryText)
                    .padding(.top, 9)
            }
        }
    }
}

#Preview {
    SplashView()
}
