//
//  PreviewContainer.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 13/10/2024.
//

import Foundation

import SwiftData
import SwiftUI

let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Card.self,
            Chapter.self
        ])
        let container = try ModelContainer(for: schema, configurations: config)
        
        Task { @MainActor in
            container.mainContext.insert(Chapter(chapterDTO: ChapterDTO.sample))
            try? container.mainContext.save()
        }

        return container
    } catch {
        fatalError("Failed to create container: \(error.localizedDescription)")
    }
}()
