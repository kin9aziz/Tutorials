//
//  PlayerView.swift
//  MoviePicker
//
//  Created by Quang Tran on 2/18/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var playerLayer: AVPlayerLayer {
        guard let layer = layer as? AVPlayerLayer else {
            fatalError("Expected `AVPlayerLayer` type for layer. Check PlayerView.layerClass implementation.")
        }
        return layer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
