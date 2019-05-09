//
//  ViewController.swift
//  BasicVideoPlayer
//
//  Created by Quang Tran on 2/11/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    var player = AVPlayer()
    var playerViewcontroller = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func playVideo(_ sender: Any) {
        guard let url = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8") else {
            return
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        playerViewcontroller.player = player
        playerViewcontroller.showsPlaybackControls = true
        
        // Modally present the player and call the player's play() method when complete.
        present(playerViewcontroller, animated: true) {
            self.player.play()
        }
    }
    
    public func disconnectAVPlayer() {
        playerViewcontroller.player = nil
    }
    
    public func reconnectAVPlayer() {
        playerViewcontroller.player = player
    }
    
    
}

