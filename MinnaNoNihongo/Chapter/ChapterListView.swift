//
//  ChapterListView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 16/10/2024.
//

import SwiftData
import SwiftUI

struct ChapterListView: View {
    @EnvironmentObject var router: Router
    
    private let modelContainer: ModelContainer
    private let chapterViewModel: ChapterQueryViewModel
    
    private let isTraining: Bool
    
    @State private var chapters: [ChapterDTO] = []
    @State private var loading = true
    
    init(modelContainer: ModelContainer, isTraining: Bool) {
        self.modelContainer = modelContainer
        chapterViewModel = ChapterQueryViewModel(modelContainer: modelContainer)
        
        self.isTraining = isTraining
    }
    
    var body: some View {
        VStack {
            if !loading {
                List {
                    Section {
                        HStack {
                            Text("Hiragana & Katakana")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.gray)
                        
                        ForEach(chapters, id:\.self.id) { chapter in
                            HStack {
                                Text("Chapter \(chapter.chapter)")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                router.navigate(to: .chapter(isTraining, chapter.chapter))
                            }
                        }
                    } header: {
                        Text("Available chapters")
                    }
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            if loading {
                chapters = (try? await chapterViewModel.backgroundFetchAll()) ?? []
                loading.toggle()
            }
        }
    }
}

#Preview {
    ChapterListView(modelContainer: previewContainer, isTraining: false)
}
