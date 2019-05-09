//
//  ViewController.swift
//  QueuePlayer
//
//  Created by Quang Tran on 2/12/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVPlayer!
    var playerItems = [AVPlayerItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadSongListIntoPlayerItems()
        
        // Register the notification when player item finished playing to play next song
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerItemDidFinishPlaying(sender:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
        
        // Init player with first player item
        player = AVPlayer(playerItem: playerItems.first)
        
        // Play first player item
        player.play()
        
        printCurrentSongName()
    }
    
    func printCurrentSongName() {
        let urlAsset = player.currentItem!.asset as! AVURLAsset
        print("Current song: \(urlAsset.url.lastPathComponent)")
    }
    
    func loadSongListIntoPlayerItems() {
        // Load all songs in songs bundle
        var urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "Songs.bundle")
        
        // Sort by file name order
        urls!.sort(by: { $0.lastPathComponent < $1.lastPathComponent })
        
        // Convert urls into player items
        for url in urls! {
            print("File name: \(url.lastPathComponent)")
            let item = AVPlayerItem(url: url)
            playerItems.append(item)
            
        }
    }

    // Receive the notification when player item finished playing to play next song
    @objc func playerItemDidFinishPlaying(sender: Notification) {
        // Get the current player item and its index
        if let currentPlayerItem = player.currentItem,
            let index = playerItems.firstIndex(of: currentPlayerItem) {
            
            // B/c AVPlayerItem is a dynamic object, so it store its current playing position
            // Next time, when you play it then it will continue play at the current position.
            // In this case, the current player item played at the end position
            // when you play it again then it will play at the end position
            // and you will not hear any sound.
            // So let it continue playing at the starting position
            // you need to seek it to the starting position as follows:
            currentPlayerItem.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), completionHandler: nil)
            
            // Get next player item
            let nextPlayerItem = playerItems[(index + 1) % playerItems.count]
            
            // Replace current player item with next player item
            player.replaceCurrentItem(with: nextPlayerItem)
            
            // Play it
            player.play()
            
            printCurrentSongName()
        }
    }
}


//        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem), options: [.old, .new], context: nil)

//override func observeValue(
//    forKeyPath keyPath: String?,
//    of object: Any?,
//    change: [NSKeyValueChangeKey : Any]?,
//    context: UnsafeMutableRawPointer?) {
//
//    if keyPath == #keyPath(AVPlayer.currentItem) {
//        if let item = change?[.newKey] as? AVPlayerItem {
//            let urlAsset = item.asset as! AVURLAsset
//            print("\(urlAsset.url.deletingPathExtension().lastPathComponent)")
//        }
//    }
//}

//        let urlAsset = player.currentItem!.asset as! AVURLAsset
//        print("\(urlAsset.url.deletingPathExtension().lastPathComponent)")

//    @IBAction func playNext(_ sender: Any) {
//        let currentItem = player.currentItem
//        currentItem!.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), completionHandler: nil)
//        let index = items.firstIndex(of: currentItem!)
//        let nextItem = items[(index! + 1) % items.count]
//
//        let urlAsset = nextItem.asset as! AVURLAsset
//        print("next item: \(urlAsset.url.lastPathComponent)")
//
//        player.replaceCurrentItem(with: nextItem)
//        player.play()
//
//        print("status: \(player.status.rawValue)")
//
//        if let error = player.error {
//            print("error: \(error)")
//        }
//    }
