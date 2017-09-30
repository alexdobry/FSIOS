//
//  MusicPlayer.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 24.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    static let sharedHelper = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        
        if let musicURL = Bundle.main.url(forResource: "Bass17w20", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                audioPlayer!.volume = 0.25
                audioPlayer!.numberOfLoops = -1
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch {
                print("Cannot play the file")
            }
        } else {
            print("not found")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func resume() {
        audioPlayer?.play()
    }
}
