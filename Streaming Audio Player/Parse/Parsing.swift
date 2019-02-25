//
//  Parsing.swift
//  Streaming Audio Player
//
//  Created by Charles Martin Reed on 2/24/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import AVFoundation

public protocol Parsing: class {
    //MARK: - Properties
    
    var dataFormat: AVAudioFormat? { get }
    var duration: TimeInterval? { get }
    
    //have all packets been parsed?
    var isParsingComplete: Bool { get }
    
    //packet description optional because it is only utilized when binary audio data is in compressed
    var packets: [(Data, AudioStreamPacketDescription?)] { get }
    var totalFrameCount: AVAudioFrameCount? { get }
    var totalPacketCount: AVAudioPacketCount? { get }
    
    //MARK: - Methods
    func parse(data: Data) throws
    
    func frameOffset(forTime time: TimeInterval) -> AVAudioFramePosition?
    
    func packetOffset(forFrame frame: AVAudioFramePosition) -> AVAudioPacketCount?
    
    func timeOffset(forFrame frame: AVAudioFrameCount) -> TimeInterval?
}

extension Parsing {
    //provide a default implementation
    public var duration: TimeInterval? {
        guard let sampleRate = dataFormat?.sampleRate else {
            return nil
        }
        
        guard let totalFrameCount = totalFrameCount else {
            return nil
        }
        
        return TimeInterval(totalFrameCount) / TimeInterval(sampleRate)
    }
    
    public var totalFrameCount: AVAudioFrameCount? {
        guard let framesPerPacket = dataFormat?.streamDescription.pointee.mFramesPerPacket else {
            return nil
        }
        
        guard let totalPacketCount = totalPacketCount else {
            return nil
        }
        
        return AVAudioFrameCount(totalPacketCount) * AVAudioFrameCount(framesPerPacket)
    }
    
    public var isParsingComplete: Bool {
        guard let totalPacketCount = totalPacketCount else {
            return false
        }
        
        return packets.count == totalPacketCount
    }
    
    public func frameOffset(forTime time: TimeInterval) -> AVAudioFramePosition? {
        guard let _ = dataFormat?.streamDescription.pointee,
            let frameCount = totalFrameCount,
            let duration = duration else {
                return nil
        }
        
        let ratio = time / duration
        return AVAudioFramePosition(Double(frameCount) * ratio)
    }
    
    public func timeOffset(forFrame frame: AVAudioFrameCount) -> TimeInterval? {
        guard let _ = dataFormat?.streamDescription.pointee,
            let frameCount = totalFrameCount,
            let duration = duration else {
                return nil
        }
        
        return TimeInterval(frame) / TimeInterval(frameCount) * duration
    }
}
