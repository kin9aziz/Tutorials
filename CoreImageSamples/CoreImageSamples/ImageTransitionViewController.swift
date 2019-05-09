//
//  ImageTransitionViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/14/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import simd

class ImageTransitionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var time: TimeInterval!
    var dt: TimeInterval!
    var displayLink: CADisplayLink!
    var sourceCIImage: CIImage!
    var finalCIImage: CIImage!
    let ciContext = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sourceCIImage = CIImage(cgImage: UIImage(named: "bird")!.cgImage!)
        finalCIImage = CIImage(cgImage: UIImage(named: "furniture")!.cgImage!)
        
        beginTransition()
    }
    
    func beginTransition() {
        time = 0
        dt = 0.005
        
        displayLink = CADisplayLink(target: self,
                                    selector: #selector(stepTime))
        displayLink.add(to: RunLoop.current,
                        forMode: RunLoop.Mode.default)
    }
    
    @objc
    func stepTime() {
        
        time += dt
        
        // End transition after 1 second
        if time > 1 {
            displayLink.remove(from:RunLoop.main, forMode:RunLoop.Mode.default)
        } else {
            guard let dissolvedCIImage = dissolveFilter(sourceCIImage,
                                                        to:finalCIImage,
                                                        time:time) else {
                                                            return
            }
            guard let pixelatedCIImage = pixelateFilter(dissolvedCIImage,
                                                        time:time) else {
                                                            return
            }
            // imageView and ciContext are properties of the class.
            showCIImage(pixelatedCIImage, in:imageView, context:ciContext)
        }
    }
    
    func showCIImage(_ ciImage: CIImage,
                     in imageView: UIImageView,
                     context: CIContext) {
        
        guard let cgImage = context.createCGImage(ciImage,
                                                  from: ciImage.extent) else {
                                                    return
        }
        let uiImage = UIImage(cgImage:cgImage)
        
        imageView.image = uiImage
    }
    
    func dissolveFilter(_ inputImage: CIImage,
                        to targetImage: CIImage,
                        time: TimeInterval) -> CIImage? {
        
        let inputTime = simd_smoothstep(0, 1, time)
        
        guard let filter = CIFilter(name:"CIDissolveTransition",
                                    parameters:
            [
                kCIInputImageKey: inputImage,
                kCIInputTargetImageKey: targetImage,
                kCIInputTimeKey: inputTime
            ]) else {
                return nil
        }
        
        return filter.outputImage
    }
    
    func pixelateFilter(_ inputImage: CIImage, time: TimeInterval) -> CIImage? {
        var inputScale = simd_smoothstep(0, 1, abs(time))
        let scale = 20.0
        if inputScale < 0.5 {
            inputScale *= scale * 2
        }
        else {
            inputScale = (1 - inputScale) * scale * 2
        }
        
        guard let filter = CIFilter(name:"CIPixellate",
                                    parameters:
            [
                kCIInputImageKey: inputImage,
                kCIInputScaleKey: inputScale
            ]) else {
                return nil
        }
        
        return filter.outputImage
    }
}
