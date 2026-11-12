//
//  SearchBarView.swift
//  Journali
//
//  Created by shatha on 01/06/1448 AH.
//


import SwiftUI

struct SearchBarView: View {

    @Bindable var viewModel: JournalViewModel

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.secondaryText)

            TextField("Search", text: $viewModel.searchText)
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.primaryText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

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
