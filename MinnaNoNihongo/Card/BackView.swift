//
//  BackView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct BackView: View {
    var card: CardDTO
    
    @Binding var background: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(background)
                .shadow(radius: 10)
            
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    TextToSpeech(text: card.kana, size: 40)
                }
                
                Spacer()
            }
            
            VStack {
                if !card.sampleKanji.isEmpty {
                    Spacer()
                }
                
                FuriganaView(card.furigana, size: 40)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                Text(LocalizedStringKey(card.traduction))
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                if !card.sampleKanji.isEmpty {
                    Spacer()
                    Divider()
                    
                    FuriganaView(card.sampleKanji, size: 20)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    Text(LocalizedStringKey(card.sampleTraduction))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
            }
            .padding(20)
            
            VStack {
                Spacer()
                
                HStack {
                    Text(card.tags)
                        .font(.caption)
                        .padding(.bottom, 4)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .transition(.identity)
        .frame(width: 250, height: 450)
    }
}

#Preview {
    @Previewable @State var background: Color = .white
    
    return BackView(
        card: CardDTO.sample,
        background: $background
    )
}
