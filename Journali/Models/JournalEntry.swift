//
//  JournalEntry.swift
//  Journali
//
//  Created by shatha on 29/05/1448 AH.
//

import SwiftData
import Foundation

@Model
final class JournalEntry {

    // MARK: - Properties
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var isBookmarked: Bool

    // MARK: - Initializer
    init(
        title: String,
        content: String
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.isBookmarked = false
    }
}
