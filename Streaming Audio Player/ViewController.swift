//
//  ViewController.swift
//  Streaming Audio Player
//
//  Created by Charles Martin Reed on 2/23/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    //MARK:- AV Properties
    let engine = AVAudioEngine() //group of connected audio nodes for generating, processing audio, in and out - Obj-C/Swift based
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVPlayer()
    }
    
    private func setupAVPlayer() {
        if let url = URL(string: "https://cdn.fastlearner.media/bensound-rumble.mp3") {
            let player = AVPlayer(url: url)
            player.play()
        }
    }
    //MARK:- About AUGraph
//    last node of an audio graph pulls data from it's previously connected node.
//    Previously connected node from next node down the chain until first node reached.
//    Audio data is pulled from the audio graph during EACH render cycle
//    Each node in an an AUGraph handles a SPECIFIC function - generating, modifying, outputting
//    The generator sits at the HEAD of an audio graph - in a chain like guitar into reverb pedal into amp, the guitar is the generator node
//    AUGraph nodes are called AUNodes, which wrap AudioUnits
//    AUs, or Audio Units, contain implementations for generating, modifying and outputting sound streams and providing I/O to sound hardware on Apple devices.
    
//    Core Audio TYPES provide high level descriptions of what an Audio Unit does (generator? mixer?, effect?)
//    Core Audio SUBTYPES describe specifically what a type of AU does - what KIND of effect is it? Distortion? Filter?
//
//    Specific audio units include things like kAudioUnitType_Output
    
//    AUGraph requires audio data to be in LPCM, which requires the decoding necessary for working with internet streams to be handled by the programmer

    
    //MARK:- AVAudioEngine steps
    //1 - Create the engine - AVAudioEngine
    
    //2 - Create the nodes - AVAudioPlayerNode()
    
    //3 - Attach the nodes - .attach
    
    //4 - Prepare the engine - .prepare
    
    //5 - Schedule the file - do { try AVAudioFile... .scheduleFile }
    
    //6 - Setup node parameters - .delayTime, .feedback
    
    //7- Start the engine and player node - engine.start, playerNode.play
}

