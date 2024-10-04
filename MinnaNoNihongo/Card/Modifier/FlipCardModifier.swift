//
//  FlipCardModifier.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct FlipCard: ViewModifier {
    @Binding var angle: Double
    @Binding var cardStatus: CardStatus
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                Angle(degrees: angle),
                axis: (x: 0, y: 1, z: 0)
            )
            .onTapGesture {
                if cardStatus == CardStatus.FRONT {
                    withAnimation(Animation.easeIn(duration: 0.50), {
                        angle = -90
                    }, completion: {
                        withAnimation(Animation.easeOut(duration: 0.25), {
                            cardStatus = CardStatus.BACK
                            angle = -180
                        })
                    })
                }
            }
    }
}

extension View {
    func flipCardOnTap(angle: Binding<Double>, cardStatus: Binding<CardStatus>) -> some View {
        modifier(FlipCard(angle: angle, cardStatus: cardStatus))
    }
}
