//
//  Audio.swift
//  FBLA Trivia
//
//  Created by Tanner York on 2/5/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class Audio {
    

var wrongSoundEffect: AVAudioPlayer?
var rightSoundEffect: AVAudioPlayer?


    func playWrongAnswerSound() {
        
        let path = Bundle.main.path(forResource: "example.mps", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            wrongSoundEffect = try AVAudioPlayer(contentsOf: url)
            sleep(1)
            wrongSoundEffect?.stop()
        } catch {
            print("Couldn't load audio file :(")
        }
    }
    
    func playRightAnswerSound() {
        let path = Bundle.main.path(forResource: "example.mps", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            rightSoundEffect = try AVAudioPlayer(contentsOf: url)
            sleep(1)
            rightSoundEffect?.stop()
        } catch {
            print("Couldn't load audio file :(")
        }
    }

    
    
}
