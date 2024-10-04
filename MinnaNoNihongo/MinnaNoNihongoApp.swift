//
//  MinnaNoNihongoApp.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import SwiftUI
import SwiftData

@main
struct MinnaNoNihongoApp: App {
    @ObservedObject var router = Router()
    
    let sharedModelContainer: ModelContainer = {
        print("shared container")
        let schema = Schema([
            Card.self,
            Chapter.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            return modelContainer
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView(modelContainer: sharedModelContainer)
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .test:
                            ChapterListView(modelContainer: sharedModelContainer, isTraining: false)
                        case .train:
                            ChapterListView(modelContainer: sharedModelContainer, isTraining: true)
                        case .chapter(let isTraining, let selectedChapter):
                            CardQueryView(
                                modelContainer: sharedModelContainer,
                                isTraining: isTraining,
                                selectedChapter: selectedChapter
                            )
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
