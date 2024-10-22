//
//  FrontView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct FrontView: View {
    var card: CardDTO

    @Binding var background: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(background)
                .shadow(radius: 10)
            
            RibbonView(text: card.jlpt, value: card.value)
            
            VStack {
                Text(card.kanji)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .transition(.identity)
        .frame(width: 250, height: 450)
    }
}

#Preview("Sample", traits: .sizeThatFitsLayout) {
    @Previewable @State var background: Color = .white
    
    FrontView(
        card: CardDTO.sample,
        background: $background
    )
    .padding()
    .background(.black)
}

#Preview("Sample2", traits: .sizeThatFitsLayout) {
    @Previewable @State var background: Color = .white
    
    FrontView(
        card: CardDTO.sample2,
        background: $background
    )
    .padding()
    .background(.black)
}
