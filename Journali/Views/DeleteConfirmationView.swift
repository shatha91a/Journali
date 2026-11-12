//
//  DeleteConfirmationView.swift
//  Journali
//
//  Created by shatha on 02/06/1448 AH.
//

import SwiftUI

struct DeleteConfirmationView: View {

    let onCancel: () -> Void
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {

                Text("Delete Journal?")
                    .font(AppFonts.captionMedium)
                    .foregroundStyle(AppColors.primaryText)

                Text("Are you sure you want to delete this journal?")
                    .font(AppFonts.captionSmall)
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

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
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(width: 270)
            .background(
                Color(hex: 0x1C1C1E),
                in: RoundedRectangle(cornerRadius: 24)
            )
        }
    }
}

