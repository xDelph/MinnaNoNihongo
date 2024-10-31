//
//  CardView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 27/10/2024.
//

import SwiftUI

enum CardStatus: Equatable {
    case FRONT, BACK, DISAPPEAR, NEXT
}
enum SwipeDirection {
    case none, left, right, finished
}

struct CardView: View {
    private var card: CardDTO
    private var isTraining: Bool
    
    
    private var disappeared: (_ result: CardResult) -> Void
    
    @Binding var cardStatus: CardStatus
    
    init(
        card: CardDTO,
        isTraining: Bool,
        cardStatus: Binding<CardStatus>,
        disappeared: @escaping (_ result: CardResult) -> () = {_ in }
    ) {
        self.card = card
        self.isTraining = isTraining
        self._cardStatus = cardStatus
        self.disappeared = disappeared
    }
    
    @State private var angle: Double = 0
    @State private var opacityAnimation: Double = 1.0
    @State private var offsetAnimation: CGFloat = 0
    @State private var backgroundAnimation: Color = .black
    @State private var swipeDirection: SwipeDirection = .none
    @State private var answer: CardResult = .train
    
    var body: some View {
        VStack {
            ZStack {
                if cardStatus == .FRONT {
                    FrontView(card: card, background: $backgroundAnimation)
                        .frame(maxWidth: .infinity)
                }
                
                if cardStatus == .BACK {
                    BackView(card: card, background: $backgroundAnimation)
                        .frame(maxWidth: .infinity)
                        .rotation3DEffect(
                            Angle(degrees: isTraining ? 0 : -180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
            }
            .padding(.vertical, 30)
            .flipCardOnTap(angle: $angle, cardStatus: $cardStatus)
            .if(!isTraining) { $0.addSwipeAction($swipeDirection) }
        }
        .onChange(of: swipeDirection) { _, newSwipeDirection in
            switch(newSwipeDirection) {
            case .left:
                backgroundAnimation = .red
                answer = .wrong
            case .right:
                backgroundAnimation = .green
                answer = .correct
            case .none:
                backgroundAnimation = .black
                answer = .train
            case .finished:
                cardStatus = .DISAPPEAR
                backgroundAnimation = .black
                return
            }
        }
        .onChange(of: cardStatus) { _, newCardStatus in
            switch(newCardStatus) {
            case .DISAPPEAR:
                opacityAnimation = 0
                angle = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    cardStatus = .NEXT
                }
                
            case .NEXT:
                opacityAnimation = 1
                offsetAnimation = 0
                angle = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    disappeared(answer)
                    answer = .train
                }
            case .FRONT:
                return
            case .BACK:
                return
            }
        }
        .opacity(opacityAnimation)
        .offset(x: offsetAnimation)
        .animation(.easeInOut, value: opacityAnimation)
    }
}

#Preview("Test") {
    @Previewable @State var cardStatus: CardStatus = .FRONT
    
    CardView(
        card: CardDTO.sample2,
        isTraining: false,
        cardStatus: $cardStatus
    )
    .padding(.vertical, 30)
    .padding(.horizontal, 20)
}

#Preview("Train") {
    @Previewable @State var cardStatus: CardStatus = .BACK
    
    CardView(
        card: CardDTO.sample2,
        isTraining: true,
        cardStatus: $cardStatus
    )
    .padding(.vertical, 30)
    .padding(.horizontal, 20)
}
