//
//  ViewController.swift
//  ImagePicker
//
//  Created by Quang Tran on 2/16/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie] as [String]
//        imagePickerController.allowsEditing = true
        playPauseButton.isHidden = true
    }

    func initPlayerWithMediaURL(mediaUrl: URL) {
        self.player = AVPlayer(url: mediaUrl)
        self.playerView.player = self.player
        self.playPauseButton.isHidden = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        print("Video Finished")
        // After the movie played at end. let the movie continue playing again
        // then you need to seek it to begin
        self.player.currentItem?.seek(to: CMTime(seconds: 0, preferredTimescale: 1), completionHandler: nil)
        self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func showCamera(_ sender: Any) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied {
            // Denied access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let alert = UIAlertController(title: "Unable to access the Camera",
                                          message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.",
                                          preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        }
        else if (authStatus == AVAuthorizationStatus.notDetermined) {
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            //
            // (Note: you can test for this case by deleting the app on the device, if already installed).
            // (Note: we need a usage description in our Info.plist to request access.
            //
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                }
            })
        } else {
            // Allowed access to camera, go ahead and present the UIImagePickerController.
            self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showMoviePicker(_ sender: Any) {
        if (self.player.isPlaying) {
            self.togglePlayPausePlayer(self.playPauseButton)
        }
        
        self.imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func togglePlayPausePlayer(_ sender: Any) {
        print("is playing: \(self.player.isPlaying)")
        if self.player.isPlaying {
            print("pause")
            self.player.pause()
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        else {
            print("play")
            self.player.play()
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            
            let mediaUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            `self`.initPlayerWithMediaURL(mediaUrl: mediaUrl)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
