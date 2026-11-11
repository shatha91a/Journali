//
//  EmptyStateView.swift
//  Journali
//
//  Created by shatha on 01/06/1448 AH.
//


import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: AppSpacing.medium) {

            Image("Empty")
                .resizable()
                .scaledToFit()
                .frame(width: 151.39, height: 97.32)

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

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        EmptyStateView()
    }
}
