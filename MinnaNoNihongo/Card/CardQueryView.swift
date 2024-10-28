//
//  CardQueryView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import SwiftData
import SwiftUI

struct CardQueryView: View {
    private let modelContainer: ModelContainer
    private let cardViewModel: CardQueryViewModel
    private let chapterViewModel: ChapterQueryViewModel
    
    @State private var card: CardDTO?
    @State private var loading = true
    
    private var isTraining: Bool
    private var selectedChapter: Int
    
    @State private var cardStatus: CardStatus = CardStatus.FRONT
    
    init(modelContainer: ModelContainer, isTraining: Bool, selectedChapter: Int) {
        self.modelContainer = modelContainer
        cardViewModel = CardQueryViewModel(modelContainer: modelContainer)
        chapterViewModel = ChapterQueryViewModel(modelContainer: modelContainer)
        
        self.isTraining = isTraining
        self.selectedChapter = selectedChapter
    }
    
    var body: some View {
        VStack {
            if !loading {
                if let unwrappedCard = card {
                    VStack {
                        CardView(
                            card: unwrappedCard,
                            isTraining: isTraining,
                            cardStatus: $cardStatus,
                            disappeared: {
                                Task {
                                    card = try? await chapterViewModel.backgroundFetchOneCard(
                                        for: selectedChapter,
                                        previousCard: card!
                                    )
                                    cardStatus = isTraining ? .BACK : .FRONT
                                }
                            }
                        )
                        
                        if isTraining && cardStatus != .DISAPPEAR && cardStatus != .NEXT {
                            HStack {
//                                if !isTraining {
//                                    Button() {
//                                        Task {
//                                            cardStatus = .DISAPPEAR
//                                            try? await cardViewModel.backgroundUpdateValue(card, value: -1)
//                                        }
//                                    } label: {
//                                        Image(systemName: "xmark.circle")
//                                            .resizable()
//                                            .frame(width: 50, height: 50)
//                                            .foregroundStyle(.red)
//                                    }
//                                    
//                                    Spacer()
//                                }
                                
                                Button() {
                                    Task {
                                        cardStatus = .DISAPPEAR
                                        if !isTraining {
                                            try? await cardViewModel.backgroundUpdateValue(card, value: +1)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                } else {
                    Text("No card found")
                    
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            if loading {
                self.cardStatus = isTraining ? CardStatus.BACK : CardStatus.FRONT
                
                card = try? await chapterViewModel.backgroundFetchOneCard(for: selectedChapter)
                loading.toggle()
            }
        }
    }
}

#Preview("Test") {
    MainActor.assumeIsolated {
        CardQueryView(modelContainer: previewContainer, isTraining: false, selectedChapter: 1)
    }
}

#Preview("Train") {
    MainActor.assumeIsolated {
        CardQueryView(modelContainer: previewContainer, isTraining: true, selectedChapter: 1)
    }
}
