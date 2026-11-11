//
//  SearchBarView.swift
//  Journali
//
//  Created by shatha on 01/06/1448 AH.
//


import SwiftUI

struct SearchBarView: View {

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.secondaryText)

            Text("Search")
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.secondaryText)

            Spacer()

            Image(systemName: "mic")
                .foregroundStyle(AppColors.secondaryText)
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(AppColors.surface, in: Capsule())
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

    SearchBarView()
    }
}
