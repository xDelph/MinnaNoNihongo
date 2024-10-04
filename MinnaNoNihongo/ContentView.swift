//
//  ContentView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 04/10/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {    
    let modelContainer: ModelContainer
    
    @State var isFetchingCards = true

    var body: some View {
        if (isFetchingCards) {
            ProgressView("Updating cards...")
                .task {
                    await WebService().updateDataInDatabase(modelContainer: modelContainer)
                    isFetchingCards.toggle()
                }
        } else {
            HomeView(modelContainer: modelContainer)
        }
    }
}


#Preview {
    ContentView(modelContainer: previewContainer)
}
