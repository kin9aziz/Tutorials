//
//  SelectivelyFocusingViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/14/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class SelectivelyFocusingViewController: UIViewController {

    @IBOutlet weak var stripImageView: UIImageView!
    @IBOutlet weak var circularImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        focusOnAStripOfImage()
        focusOnACircleOfImage()
    }
    
    func focusOnAStripOfImage() {
        let inputImage = CIImage(cgImage: UIImage(named: "furniture")!.cgImage!)
        let h = inputImage.extent.size.height
        
        // Performs an affine transform on a source image and then clamps the pixels
        // at the edge of the transformed image, extending them outwards.
        // Use this filter to fix the error: the edges of the blurred image become transparent
        guard let affineClamp = CIFilter(name: "CIAffineClamp") else {
            return
        }
        affineClamp.setDefaults()
        affineClamp.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let topGradient = CIFilter(name:"CILinearGradient") else {
            return
        }
        topGradient.setValue(CIVector(x:0, y:0.85 * h),
                             forKey:"inputPoint0")
        topGradient.setValue(CIColor.green,
                             forKey:"inputColor0")
        topGradient.setValue(CIVector(x:0, y:0.6 * h),
                             forKey:"inputPoint1")
        topGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                             forKey:"inputColor1")
        
        guard let bottomGradient = CIFilter(name:"CILinearGradient") else {
            return
        }
        bottomGradient.setValue(CIVector(x:0, y:0.35 * h),
                                forKey:"inputPoint0")
        bottomGradient.setValue(CIColor.green,
                                forKey:"inputColor0")
        bottomGradient.setValue(CIVector(x:0, y:0.6 * h),
                                forKey:"inputPoint1")
        bottomGradient.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                                forKey:"inputColor1")
        
        guard let gradientMask = CIFilter(name:"CIAdditionCompositing") else {
            return
        }
        gradientMask.setValue(topGradient.outputImage,
                              forKey: kCIInputImageKey)
        gradientMask.setValue(bottomGradient.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        
        guard let maskedVariableBlur = CIFilter(name:"CIMaskedVariableBlur") else {
            return
        }
        maskedVariableBlur.setValue(affineClamp.outputImage, forKey: kCIInputImageKey)
        maskedVariableBlur.setValue(20, forKey: kCIInputRadiusKey)
        maskedVariableBlur.setValue(gradientMask.outputImage, forKey: "inputMask")
        let selectivelyFocusedCIImage = maskedVariableBlur.outputImage!
        
        // B/c the blurred image is smaller than the original image
        // so we need to resize it into the size of the original image
        let context = CIContext()
        let selectivelyFocusedCGImage = context.createCGImage(selectivelyFocusedCIImage, from: inputImage.extent)
        stripImageView.image = UIImage(cgImage: selectivelyFocusedCGImage!)
    }
    
    func focusOnACircleOfImage() {
        let inputImage = CIImage(cgImage: UIImage(named: "furniture")!.cgImage!)
        let h = inputImage.extent.size.height
        let w = inputImage.extent.size.width
        
        // Performs an affine transform on a source image and then clamps the pixels
        // at the edge of the transformed image, extending them outwards.
        // Use this filter to fix the error: the edges of the blurred image become transparent
        guard let affineClamp = CIFilter(name: "CIAffineClamp") else {
            return
        }
        affineClamp.setDefaults()
        affineClamp.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let radialMask = CIFilter(name:"CIRadialGradient") else {
            return
        }
        let imageCenter = CIVector(x:0.55 * w, y:0.6 * h)
        radialMask.setValue(imageCenter, forKey:kCIInputCenterKey)
        radialMask.setValue(0.3 * h, forKey:"inputRadius0")
        radialMask.setValue(0.5 * h, forKey:"inputRadius1")
        radialMask.setValue(CIColor(red:0, green:1, blue:0, alpha:0),
                            forKey:"inputColor0")
        radialMask.setValue(CIColor(red:0, green:1, blue:0, alpha:1),
                            forKey:"inputColor1")
        
        guard let maskedVariableBlur = CIFilter(name:"CIMaskedVariableBlur") else {
            return
        }
        maskedVariableBlur.setValue(affineClamp.outputImage, forKey: kCIInputImageKey)
        maskedVariableBlur.setValue(20, forKey: kCIInputRadiusKey)
        maskedVariableBlur.setValue(radialMask.outputImage, forKey: "inputMask")
        let selectivelyFocusedCIImage = maskedVariableBlur.outputImage!
        
        // B/c the blurred image is smaller than the original image
        // so we need to resize it into the size of the original image
        let context = CIContext()
        let selectivelyFocusedCGImage = context.createCGImage(selectivelyFocusedCIImage, from: inputImage.extent)
        circularImageView.image = UIImage(cgImage: selectivelyFocusedCGImage!)
    }
}
