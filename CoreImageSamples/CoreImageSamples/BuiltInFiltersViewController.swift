//
//  ViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/13/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class BuiltInFiltersViewController: UIViewController {
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var filteredImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let originalUIImage = UIImage(named: "bird")!
        originalImageView.image = originalUIImage

        let originalCIImage = CIImage(cgImage: originalUIImage.cgImage!)

        let sepiaCIImage = sepiaFilter(originalCIImage, intensity:0.9)!

        let bloomCIImage = bloomFilter(sepiaCIImage, intensity:1, radius:10)!

        let aspectRatio = Double(originalUIImage.size.width) / Double(originalUIImage.size.height)
        let scaledCIImage = scaleFilter(bloomCIImage, aspectRatio:aspectRatio, scale:0.5)

        self.filteredImageView.image = UIImage(ciImage: scaledCIImage)
    }

    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage?
    {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    func scaleFilter(_ input:CIImage, aspectRatio : Double, scale : Double) -> CIImage
    {
        let scaleFilter = CIFilter(name:"CILanczosScaleTransform")!
        scaleFilter.setValue(input, forKey: kCIInputImageKey)
        scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
        scaleFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        return scaleFilter.outputImage!
    }
}

