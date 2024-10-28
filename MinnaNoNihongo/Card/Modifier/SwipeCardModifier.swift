//
//  SwipeCardModifier.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct SwipeCard: ViewModifier {
    @Binding var swipeDirection: SwipeDirection
    
    @State private var dragState = CGSize.zero
    @State private var cardRotation: Double = 0
    
    private let swipeThreshold: CGFloat = 150.0
    private let rotationFactor: Double = 50.0
    
    func body(content: Content) -> some View {
        content
            .offset(x: dragState.width)
            .rotationEffect(
                .degrees(cardRotation),
                anchor: swipeDirection == .left ? .trailing : .leading
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragState = gesture.translation
                        swipeDirection = dragState.width > 0 ? .right : .left
                        cardRotation = Double(gesture.translation.width) / rotationFactor * (swipeDirection == .right ? -1.0 : 1.0)
                    }
                    .onEnded { _ in
                        if abs(dragState.width) > swipeThreshold {
                            withAnimation(.easeOut(duration: 0.5)) {
                                dragState.width = dragState.width > 0 ? 1000 : -1000
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                dragState = .zero
                                cardRotation = 0
                                swipeDirection = .finished
                            }
                        } else {
                            withAnimation(.spring()) {
                                dragState = .zero
                                cardRotation = 0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                dragState = .zero
                                cardRotation = 0
                                swipeDirection = .none
                            }
                        }
                    }
            )
//            .animation(.easeInOut, value: dragState)
    }
}

extension View {
    func addSwipeAction(_ swipeDirection: Binding<SwipeDirection>) -> some View {
        modifier(SwipeCard(swipeDirection: swipeDirection))
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
}
