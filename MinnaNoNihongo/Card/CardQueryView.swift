//
//  CardQueryView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import SwiftData
import SwiftUI

enum CardStatus {
    case FRONT, BACK
}

struct CardQueryView: View {
    private let modelContainer: ModelContainer
    private let cardViewModel: CardQueryViewModel
    private let chapterViewModel: ChapterQueryViewModel
    
    @State private var card: CardDTO?
    @State private var loading = true
    
    private var isTraining: Bool
    private var selectedChapter: Int
    
    @State private var angle: Double = 0
    @State private var cardStatus: CardStatus = CardStatus.FRONT
    
    @State private var opacityAnimation: Double = 1.0
    @State private var offsetAnimation: CGFloat = 0
    @State private var backgroundAnimation: Color = .white
    
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
                        ZStack {
                            if !isTraining && cardStatus == CardStatus.FRONT {
                                FrontView(card: unwrappedCard, background: $backgroundAnimation)
                                    .fixedSize()
                            }
                            
                            if cardStatus == CardStatus.BACK{
                                BackView(card: unwrappedCard, background: $backgroundAnimation)
                                    .fixedSize()
                                    .rotation3DEffect(
                                        Angle(degrees: -180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                            }
                        }
                        .frame(width: 250, height: 450)
                        .flipCardOnTap(angle: $angle, cardStatus: $cardStatus)
                    }
                    .onChange(of: card) { _, _ in
                        if (!isTraining) {
                            cardStatus = CardStatus.FRONT
                            angle = 0
                            
                            opacityAnimation = 1
                            offsetAnimation = 0
                            backgroundAnimation = .white
                        }
                    }
                    .opacity(opacityAnimation)
                    .offset(x: offsetAnimation)
                    .animation(.smooth(duration: opacityAnimation == 1 ? 0 : 0.3), value: opacityAnimation)
                    .animation(.smooth(duration: opacityAnimation == 1 ? 0 : 0.3), value: offsetAnimation)
                    .animation(.smooth(duration: opacityAnimation == 1 ? 0 : 0.3), value: backgroundAnimation)
                    
                    HStack {
                        if !isTraining {
                            Button() {
                                Task {
                                    opacityAnimation = 0
                                    offsetAnimation = -30
                                    backgroundAnimation = .red
                                    try await Task.sleep(nanoseconds: UInt64(0.4 * Double(NSEC_PER_SEC)))
                                    
                                    try? await cardViewModel.backgroundUpdateValue(card, value: -1)
                                    card = try? await chapterViewModel.backgroundFetchOneCard(for: selectedChapter, previousCard: card!)
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.red)
                            }
                            
                            Spacer()
                        }
                        
                        Button() {
                            Task {
                                if !isTraining {
                                    opacityAnimation = 0
                                    offsetAnimation = 30
                                    backgroundAnimation = .green
                                    try await Task.sleep(nanoseconds: UInt64(0.4 * Double(NSEC_PER_SEC)))
                                }
                                
                                try? await cardViewModel.backgroundUpdateValue(card, value: +1)
                                card = try? await chapterViewModel.backgroundFetchOneCard(for: selectedChapter, previousCard: card!)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.green)
                        }
                    }
                    .frame(width: 250)
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
                self.angle = isTraining ? -180 : 0
                self.cardStatus = isTraining ? CardStatus.BACK : CardStatus.FRONT
                
                card = try? await chapterViewModel.backgroundFetchOneCard(for: selectedChapter)
                loading.toggle()
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        CardQueryView(modelContainer: previewContainer, isTraining: false, selectedChapter: 1)
    }
}
