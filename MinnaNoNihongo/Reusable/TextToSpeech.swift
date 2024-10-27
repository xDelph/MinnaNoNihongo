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
    var sound: String
    var size: CGFloat
    
    @State private var url: URL?
    
    init(sound: String, size: CGFloat) {
        self.url = Bundle.main.url(forResource: "\(sound)", withExtension: ".wav")
        self.sound = sound
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
        .task(id: sound) {
            url = nil
            url = Bundle.main.url(forResource: "\(sound)", withExtension: ".wav")
        }
        
    }
}

#Preview {
    TextToSpeech(sound: "dōzoyoroshikuonegaishimasu", size: 50)
}
