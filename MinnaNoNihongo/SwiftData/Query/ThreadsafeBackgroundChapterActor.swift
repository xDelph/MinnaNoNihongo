//
//  ThreadsafeBackgroundChapterActor.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import Foundation

import SwiftData

@ModelActor
actor ThreadsafeBackgroundChapterActor: Sendable {
    private var context: ModelContext { modelExecutor.modelContext }
    
    func updateChapters(_ dtos: [CardDTO]) throws {
        print("...updating...")
        let dictionary = Dictionary(grouping: dtos, by: { (element: CardDTO) in
            return element.chapter
        })
        dictionary.forEach({chapter, cards in
            let chapter = Chapter(chapter: chapter, cards: [])
            var chapterCards = [Card]()
            
            cards.forEach({dto in
                chapterCards.append(Card(cardDTO: dto))
            })
            
            chapter.cards = chapterCards
            context.insert(chapter)
            try? context.save()
        })
    }
    
    func fetchAll() async throws -> [ChapterDTO] {
        let descriptor = FetchDescriptor<Chapter>(sortBy: [SortDescriptor(\Chapter.chapter)])
        let chapters: [Chapter] = try context.fetch(descriptor)
        let chapterDTOs = chapters.map{ChapterDTO(chapter: $0)}
        
        return chapterDTOs
    }
    
    func fetchCount() async -> Int {
        let descriptor = FetchDescriptor<Chapter>()
        let count = try? context.fetchCount(descriptor)
        
        return count ?? 0
    }
    
    func fetchOne(chapter: Int) async throws -> ChapterDTO? {
        let descriptor = FetchDescriptor<Chapter>(
            predicate: #Predicate { $0.chapter == chapter }
        )
        let chapters: [Chapter] = try context.fetch(descriptor)
        let chapter = chapters.first
        
        if let chapter = chapter {
            return ChapterDTO(chapter: chapter)
        } else {
            return nil
        }
    }
}

