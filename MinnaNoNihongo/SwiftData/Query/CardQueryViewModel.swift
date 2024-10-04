//
//  CardQueryViewModel.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import SwiftData

@Observable
final class CardQueryViewModel: Sendable {
    let modelContainer: ModelContainer
    let backgroundActor: ThreadsafeBackgroundCardActor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.backgroundActor = ThreadsafeBackgroundCardActor(modelContainer: modelContainer)
    }
    
    func backgroundFetch(old: CardDTO = CardDTO.empty) async throws -> CardDTO? {
        return try await backgroundActor.fetchRandom(not: old)
    }
    
    func backgroundUpdateValue(_ dto: CardDTO?, value: Int) async throws {
        if let dto = dto {
            try await backgroundActor.updateValue(dto: dto, value: value)
        }
    }
}
