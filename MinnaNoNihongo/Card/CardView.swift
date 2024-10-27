//
//  CardView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 27/10/2024.
//

import SwiftUI

enum CardStatus: Equatable {
    case FRONT, BACK, DISAPPEAR_NOK, DISAPPEAR_OK, DISAPPEAR_TRAINING, NEXT
}

struct CardView: View {
    var card: CardDTO
    var isTraining: Bool
    
    var disappeared: () -> ()?
    
    @Binding var cardStatus: CardStatus
    
    init(
        card: CardDTO,
        isTraining: Bool,
        cardStatus: Binding<CardStatus>,
        disappeared: @escaping () -> () = {}
    ) {
        self.card = card
        self.isTraining = isTraining
        self._cardStatus = cardStatus
        self.disappeared = disappeared
    }
    
    @State private var angle: Double = 0
    @State private var opacityAnimation: Double = 1.0
    @State private var offsetAnimation: CGFloat = 0
    @State private var backgroundAnimation: Color = .white
    
    var body: some View {
        VStack {
            ZStack {
                if cardStatus == .FRONT {
                    FrontView(card: card, background: $backgroundAnimation)
                        .frame(maxWidth: .infinity)
                }
                
                if cardStatus != .FRONT && cardStatus != .NEXT {
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
        }
        .onChange(of: cardStatus) { _, newValue in
            switch(newValue) {
            case .DISAPPEAR_NOK :
                withAnimation(Animation.easeOut(duration: 0.25), {
                    opacityAnimation = 0
                    offsetAnimation = -30
                    backgroundAnimation = .red
                }, completion: {
                    angle = 0
                    cardStatus = .NEXT
                })
                
            case .DISAPPEAR_OK :
                withAnimation(Animation.easeOut(duration: 0.25), {
                    opacityAnimation = 0
                    offsetAnimation = 30
                    backgroundAnimation = .green
                }, completion: {
                    angle = 0
                    cardStatus = .NEXT
                })
                
            case .DISAPPEAR_TRAINING :
                withAnimation(Animation.easeOut(duration: 0.25), {
                    opacityAnimation = 0
                }, completion: {
                    angle = 0
                    cardStatus = .NEXT
                })
                
            case .NEXT :
                opacityAnimation = 1
                offsetAnimation = 0
                backgroundAnimation = .white
                
                
                cardStatus = isTraining ? .BACK : .FRONT
                disappeared()
            
            case .FRONT:
                return
            case .BACK:
                return
            }
        }
        .opacity(opacityAnimation)
        .offset(x: offsetAnimation)
    }
}

#Preview {
    @Previewable @State var cardStatus: CardStatus = .FRONT
    
    CardView(
        card: CardDTO.sample2,
        isTraining: false,
        cardStatus: $cardStatus
    )
    .padding(.vertical, 30)
    .padding(.horizontal, 20)
    .onTapGesture(count: 2) {
        if cardStatus == .BACK {
            cardStatus = .DISAPPEAR_TRAINING
        }
    }
}
