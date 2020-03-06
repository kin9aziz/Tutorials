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
  
  let videoUrl = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!
  lazy var player: AVPlayer = {
    return AVPlayer(url: videoUrl)
  }()
  lazy var playerViewController: AVPlayerViewController = {
    let vc = AVPlayerViewController()
    vc.player = self.player
    vc.showsPlaybackControls = true
    return vc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func showVideo(_ sender: Any) {
    present(playerViewController, animated: true) {
      self.player.play()
    }
  }
  
  public func disconnectAVPlayer() {
    playerViewController.player = nil
  }
  
  public func reconnectAVPlayer() {
    playerViewController.player = player
  }
  
}
