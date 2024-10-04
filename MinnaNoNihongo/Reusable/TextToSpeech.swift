//
//  TextToSpeech.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 06/10/2024.
//

import AVFoundation
var player: AVAudioPlayer?

import SwiftUI

@MainActor
struct TextToSpeech: View {
    var text: String
    var size: CGFloat
    
    let elevenApi = ElevenLabsApi()
    @State private var url: URL?
    
    init(text: String, size: CGFloat) {
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
            url = try? await self.elevenApi.textToSpeech(voice_id: "8EkOjt4xTPGMclNlh1pk", text: text, model: "eleven_turbo_v2_5")
        }
        
    }
}

#Preview {
    TextToSpeech(text: "Ohayou Gozaimasu", size: 50)
}
