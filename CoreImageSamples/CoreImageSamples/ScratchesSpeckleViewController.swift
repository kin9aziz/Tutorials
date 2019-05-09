//
//  ScratchesSpeckleViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/14/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ScratchesSpeckleViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let inputImage = CIImage(cgImage: UIImage(named: "furniture")!.cgImage!)
        
        guard let sepiaFilter = CIFilter(name:"CISepiaTone",
                                         parameters:
            [
                kCIInputImageKey: inputImage,
                kCIInputIntensityKey: 1.0
            ]) else {
                return
        }
        guard let sepiaCIImage = sepiaFilter.outputImage else {
            return
        }
        
        guard
            let coloredNoise = CIFilter(name:"CIRandomGenerator"),
            let noiseImage = coloredNoise.outputImage
            else {
                return
        }
        
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        guard
            let whiteningFilter = CIFilter(name:"CIColorMatrix",
                                           parameters:
                [
                    kCIInputImageKey: noiseImage,
                    "inputRVector": whitenVector,
                    "inputGVector": whitenVector,
                    "inputBVector": whitenVector,
                    "inputAVector": fineGrain,
                    "inputBiasVector": zeroVector
                ]),
            let whiteSpecks = whiteningFilter.outputImage
            else {
                return
        }
        
        guard
            let speckCompositor = CIFilter(name:"CISourceOverCompositing",
                                           parameters:
                [
                    kCIInputImageKey: whiteSpecks,
                    kCIInputBackgroundImageKey: sepiaCIImage
                ]),
            let speckledImage = speckCompositor.outputImage
            else {
                return
        }

        let verticalScale = CGAffineTransform(scaleX: 1.5, y: 25)
        let transformedNoise = noiseImage.transformed(by: verticalScale)
        
        let darkenVector = CIVector(x: 4, y: 0, z: 0, w: 0)
        let darkenBias = CIVector(x: 0, y: 1, z: 1, w: 1)
        
        guard
            let darkeningFilter = CIFilter(name:"CIColorMatrix",
                                           parameters:
                [
                    kCIInputImageKey: transformedNoise,
                    "inputRVector": darkenVector,
                    "inputGVector": zeroVector,
                    "inputBVector": zeroVector,
                    "inputAVector": zeroVector,
                    "inputBiasVector": darkenBias
                ]),
            let randomScratches = darkeningFilter.outputImage
            else {
                return
        }
        
        guard
            let grayscaleFilter = CIFilter(name:"CIMinimumComponent",
                                           parameters:
                [
                    kCIInputImageKey: randomScratches
                ]),
            let darkScratches = grayscaleFilter.outputImage
            else {
                return
        }

        guard let oldFilmCompositor = CIFilter(name:"CIMultiplyCompositing",
                                             parameters:
                [
                    kCIInputImageKey: darkScratches,
                    kCIInputBackgroundImageKey: speckledImage
                ]),
            let oldFilmImage = oldFilmCompositor.outputImage
            else {
                return
        }
        
        let finalImage = oldFilmImage.cropped(to: inputImage.extent)

        self.imageView.image = UIImage(ciImage: finalImage)
    }
    
}
