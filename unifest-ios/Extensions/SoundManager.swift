//
//  SoundManager.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/14/24.
//

import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ""))
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not find and play the sound file!")
            }
        }
    }
}

struct GameView: View {
    @ObservedObject var soundManager = SoundManager()

    var body: some View {
        VStack {
            Button(action: {
                soundManager.playSound(sound: "jump", type: "wav")
            }) {
                Text("Jump Sound")
            }

            Button(action: {
                soundManager.playSound(sound: "coin", type: "mp3")
            }) {
                Text("Coin Sound")
            }
        }
    }
}

#Preview {
    GameView()
}
