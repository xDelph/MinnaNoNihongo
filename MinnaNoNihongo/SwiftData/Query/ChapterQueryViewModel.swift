//
//  ChapterQueryViewModel.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import SwiftData

@Observable
final class ChapterQueryViewModel: Sendable {
    let modelContainer: ModelContainer
    let backgroundActor: ThreadsafeBackgroundChapterActor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.backgroundActor = ThreadsafeBackgroundChapterActor(modelContainer: modelContainer)
    }
    
    func backgroundFetchAll() async throws -> [ChapterDTO] {
        return try await backgroundActor.fetchAll()
    }
    
    func backgroundFetchOne(chapter: Int) async throws -> ChapterDTO? {
        return try await backgroundActor.fetchOne(chapter: chapter)
    }
    
    func backgroundFetchOneCard(for chapter: Int, previousCard: CardDTO = CardDTO.empty) async throws -> CardDTO? {
        let chapter = try await backgroundActor.fetchOne(chapter: chapter)
    
        let cards = (chapter?.cards ?? []).filter { card in card.kana != previousCard.kana }
        let card = cards.randomElement()
        
        if let card = card {
            return card
        } else {
            return nil
        }
    }
}
