//
//  ThreaddageBackgroundCardActor.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import Foundation

import SwiftData

@ModelActor
actor ThreadsafeBackgroundCardActor: Sendable {
    private var context: ModelContext { modelExecutor.modelContext }
    
    func fetchData() async throws -> [CardDTO] {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\Card.id)])
        let cards: [Card] = try context.fetch(descriptor)
        let cardDTOs = cards.map{CardDTO(card: $0)}
        
        return cardDTOs
    }
    
    func fetchCount() async -> Int {
        let descriptor = FetchDescriptor<Card>()
        let count = try? context.fetchCount(descriptor)
        
        return count ?? 0
    }
    
    func fetchRandom(not: CardDTO) async throws -> CardDTO? {
        let kana = not.kana
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { $0.kana != kana },
            sortBy: [SortDescriptor(\Card.value)]
        )
        let cards: [Card] = try context.fetch(descriptor)
        let card = cards.randomElement()
        
        if let card = card {
            return CardDTO(card: card)
        } else {
            return nil
        }
    }
    
    func updateValue(dto: CardDTO, value: Int) async throws {
        let kana = dto.kana
        let descriptor = FetchDescriptor<Card>(predicate: #Predicate { $0.kana == kana })
        let cards: [Card] = try context.fetch(descriptor)
        
        if let card = cards.first {
            card.value += value
        }
    }
    
    func resetValues() async throws {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\Card.id)])
        let cards: [Card] = try context.fetch(descriptor)
        
        for card in cards {
            card.value = 0
        }
    }
}

