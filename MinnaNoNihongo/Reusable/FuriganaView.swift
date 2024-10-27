//
//  FuriganaView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct Furigana: Identifiable {
    let id = UUID()
    
    var kanji: String;
    var kana: String;
    
    var bold: Bool = false;
}

struct FuriganaView: View {
    var furiganas: [[Furigana]] = []
    var size: Int

    init(_ text: String, size: Int = 17) {
        self.size = size
        
        var furiganas: [Furigana] = []
        
        let matches: [String] = text
            .replacingOccurrences(of: "&lt;b&gt;", with: "**")
            .replacingOccurrences(of: "&lt;/b&gt;", with: "**")
            .matches(of: /((\*\*)?(\p{Script=Han})*\[(\p{Script=Hiragana})*\](\*\*)?)|(\p{Script=Katakana}|\p{Script=Hiragana})|(〜|\~|\/|\(|\))/)
            .map { String($0.output.0) }
        
        for match in matches {
            let bold = match.contains("**")
            let newMatch = match.replacingOccurrences(of: "**", with: "")
            
            let kanji = String(newMatch.split(separator: "[").first ?? Substring())
            
            if kanji != " " {
                furiganas.append(Furigana(
                    kanji: kanji,
                    kana: String(newMatch.dropFirst(kanji.count+1).dropLast()),
                    bold: bold
                ))
            }
        }
        
        self.furiganas = furiganas.chunked(maxChunk: 2, minSize: 8)
    }
    
    func furiganaView(_ furiganas: [Furigana]) -> some View {
        HStack(alignment: .bottom, spacing: -3) {
            ForEach(furiganas) { furigana in
                VStack(alignment: .center) {
                    Text(furigana.kana)
                        .font(.system(size: CGFloat(size/2)))
                        .offset(y: 3)
//                        .frame(width: CGFloat(size*furigana.kanji.count*2))
                        .fontWeight(furigana.bold ? .bold : .regular)
                    Text(furigana.kanji)
//                        .font(.system(size: CGFloat(size)))
                        .fontWeight(furigana.bold ? .bold : .regular)
                }
                                        .font(.system(size: CGFloat(size)))
//                .frame(width: CGFloat(size*furigana.kanji.count))
            }
        }
    }
    
    var body: some View {
        ForEach(0..<furiganas.count, id: \.self) { i in
            furiganaView(furiganas[i])
        }
    }
}

#Preview {
    VStack {
        FuriganaView("〜あの 人[ひと]", size: 70)
        
        FuriganaView("あの", size: 60)
        
        FuriganaView("失[ひと]の 人[ひとひ]", size: 40)
        FuriganaView("失礼[しつれい]ですが")
        FuriganaView("あなたは &lt;b&gt;英語[えいご]&lt;/b&gt;が 話[はな]せますか&lt;br&gt;(～が～える/できる)", size: 40)
    }
}
