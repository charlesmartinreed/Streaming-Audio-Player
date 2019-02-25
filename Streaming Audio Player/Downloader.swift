//
//  Downloader.swift
//  Streaming Audio Player
//
//  Created by Charles Martin Reed on 2/24/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import Foundation
import UIKit

public class Downloader: NSObject {
    //MARK:- Conformation properties
    public var delegate: DownloadingDelegate?
    public var completionHandler: ((Error?) -> Void)?
    public var progress: Float = 0
    public var progressHandler: ((Data, Float) -> Void)?
    public var state: DownloadingState = .notStarted {
        didSet {
            delegate?.download(self, changedState: state)
        }
    }
    
    public var totalBytesReceived: Int64 = 0
    public var totalBytesCount: Int64 = 0
    public var url: URL? {
        didSet {
            if state == .started {
                stop()
            }
            
            if let url = url {
                progress = 0.0
                state = .notStarted
                totalBytesCount = 0
                totalBytesReceived = 0
                task = session.dataTask(with: url)
            } else {
                task = nil
            }
        }
    }
    
    //MARK:- URLSession properties
    fileprivate lazy var session: URLSession = {
       return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    fileprivate var task: URLSessionDataTask?
    
    
}

//MARK:- Downloading delegate methods
extension Downloader: Downloading {
    
    public func start() {
        guard let task = task else { return }
        switch state {
        case .completed, .started:
            return
        default:
            state = .started
            task.resume()
        }
    }
    
    public func pause() {
        guard let task = task else { return }
        guard state == .started else { return }
        state = .paused
        task.suspend()
    }
    
    public func stop() {
        guard let task = task else { return }
        guard state == .started else { return }
        state = .stopped
        task.cancel()
    }
    
}

//MARK:- URLSession delegate methods
extension Downloader: URLSessionDataDelegate {
    //handles task level events
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        //grab the length of our content and proceed with the loading
        totalBytesCount = response.expectedContentLength
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //pull in the binary audio data, report it to our delegate 
        totalBytesReceived += Int64(data.count)
        progress = Float(totalBytesReceived) / Float(totalBytesCount)
        delegate?.download(self, didReceiveData: data, progress: progress)
        progressHandler?(data, progress)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate?.download(self, completedWithError: error)
        completionHandler?(error)
    }
}
