//
//  DownloadingState.swift
//  Streaming Audio Player
//
//  Created by Charles Martin Reed on 2/23/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import Foundation
import UIKit

public enum DownloadingState: String {
    case completed, started, paused, notStarted, stopped
}
