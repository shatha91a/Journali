//
//  JournalEntry.swift
//  Journali
//
//  Created by shatha on 29/05/1448 AH.
//

import Foundation

struct JournalEntry: Identifiable {
    let id: UUID
    var title: String
    var content: String
    let createdAt: Date
    init(
        title: String,
        content: String
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
    }
}

