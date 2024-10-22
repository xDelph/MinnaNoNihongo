//
//  TextToSpeech.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import AVFoundation
var player: AVAudioPlayer?

import Foundation

import SwiftUI

@MainActor
struct TextToSpeech: View {
    var text: String
    var size: CGFloat
    
    @State private var url: URL?
    
    init(text: String, size: CGFloat) {
        self.url = Bundle.main.url(forResource: "\(text)", withExtension: ".wav")
        self.text = text.replacingOccurrences(of: "〜", with: "")
        self.size = size
    }
    
    func playSound(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Button {
            Task {
                if let url = url {
                    playSound(url: url)
                }
            }
        } label: {
            Image(systemName: "play.circle")
                .resizable()
                .frame(width: size, height: size)
                .padding()
        }
        .tint(.black)
        .task(id: text) {
            url = nil
            url = Bundle.main.url(forResource: "\(text)", withExtension: ".wav")
        }
        
    }
}

#Preview {
    TextToSpeech(text: "あなたの お おとうさんはおいくつですか", size: 50)
}
