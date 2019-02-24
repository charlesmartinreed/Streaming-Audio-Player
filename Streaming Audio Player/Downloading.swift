//
//  Downloading.swift
//  Streaming Audio Player
//
//  Created by Charles Martin Reed on 2/23/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//
//  Downloading is a Protocol used to fetch audio data over the internet when presented with a URL

import Foundation
import UIKit

public protocol Downloading: class {
    // MARK:- Protocol Properties
    
    var delegate: DownloadingDelegate? { get set }
    
    //ranges from 0.0 - 1.0
    var progress: Float { get set }
    
    var state: DownloadingState { get set }
    // optional to allow for Singleton use in the event that many different URLs are utilized from a common cache
    var url: URL? { get set }
    
    // MARK:- Protocol Methods
    func start()
    
    func pause()
    
    //should invalidate all cached data under the hood
    func stop()
}

public protocol DownloadingDelegate: class {
    func download(_ download: Downloading, changedState state: DownloadingState)
    func download(_ download: Downloading, completedWithError error: Error?)
    func download(_ download: Downloading, didReceivedData data: Data, progress: Float)
}
