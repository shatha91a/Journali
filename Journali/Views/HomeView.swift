//
//  HomeView.swift
//  Journali
//
//  Created by shatha on 01/06/1448 AH.
//

import SwiftUI

struct HomeView: View {

    var body: some View {

        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack {
                
                // MARK: - Header
                HStack {
                    Text("Journal")
                        .font(AppFonts.headingLarge)
                        .foregroundStyle(AppColors.primaryText)

                    Spacer()

                    HStack(spacing: 20) {
                        Button {
                            // Filter action - سنضيفه لاحقًا
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }

                        Button {
                            // Add action - سنضيفه لاحقًا
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppColors.surface, in: Capsule())
                }
                .padding(.horizontal, AppSpacing.medium)
                .padding(.top, AppSpacing.medium)
                Spacer()

                // MARK: - Empty State
                EmptyStateView()
                    .frame(maxWidth: .infinity)

                Spacer()
                // MARK: - Search Bar
                SearchBarView()
                    .padding(.horizontal, AppSpacing.medium)
                    .padding(.bottom, AppSpacing.medium)
            }
        }
    }
}

#Preview {
    HomeView()
}
