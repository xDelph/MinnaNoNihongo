//
//  ChapterModel.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 14/10/2024.
//

import Foundation

import SwiftData

@Model
class Chapter {
    var id: UUID
    
    @Attribute(.unique) var chapter: Int
    @Relationship(deleteRule: .cascade, inverse: \Card.chapter) var cards: [Card]

    init(
        id: UUID = UUID(),
        chapter: Int,
        cards: [Card]
    ) {
        self.id = id
        self.chapter = chapter
        self.cards = cards
    }
    
    convenience init(chapterDTO: ChapterDTO) {
        self.init(
            id: chapterDTO.id ?? UUID(),
            chapter: chapterDTO.chapter,
            cards: chapterDTO.cards.map{ cardDTO in
                Card(cardDTO: cardDTO)
            }
        )
    }
}

/// Creates Chapter Data Transfer Objects
final class ChapterDTO: Sendable, Identifiable, Codable, Equatable, Hashable {
    let id: UUID?
    
    let chapter: Int
    let cards: [CardDTO]

    init(
        id: UUID?,
        chapter: Int,
        cards: [CardDTO]
    ) {
        self.id = id ?? UUID()
        self.chapter = chapter
        self.cards = cards
    }
    
    convenience init(chapter: Chapter) {
        self.init(
            id: chapter.id,
            chapter: chapter.chapter,
            cards: chapter.cards.map{ card in
                CardDTO(card: card)
            }
        )
    }
    
    static let empty = ChapterDTO(
        id: UUID(),
        chapter: 0,
        cards: []
    )
    
    static let sample = ChapterDTO(
        id: UUID(),
        chapter: 1,
        cards: [CardDTO.sample, CardDTO.sample2]
    )
    
    static func ==(lhs: ChapterDTO, rhs: ChapterDTO) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(chapter)
        hasher.combine(id)
    }
}
