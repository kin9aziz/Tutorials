//
//  ChromaViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/13/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class ChromaViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let chromaCIFilter = self.chromaKeyFilter(fromHue: 0.3, toHue: 0.4)
        let foregroundCIImage = CIImage(cgImage: UIImage(named: "greenscreen")!.cgImage!)
        chromaCIFilter?.setValue(foregroundCIImage, forKey: kCIInputImageKey)
        let sourceCIImageWithoutBackground = chromaCIFilter?.outputImage
        
        let compositor = CIFilter(name:"CISourceOverCompositing")
        compositor?.setValue(sourceCIImageWithoutBackground, forKey: kCIInputImageKey)
        let backgroundCIImage = CIImage(cgImage: UIImage(named: "sky")!.cgImage!)
        compositor?.setValue(backgroundCIImage, forKey: kCIInputBackgroundImageKey)
        let compositedCIImage = compositor?.outputImage
        
        self.imageView.image = UIImage(ciImage: compositedCIImage!)
    }
    
    func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat) -> CIFilter?
    {
        let size = 64
        var cubeRGB = [Float]()
        
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)
                    
                    let hue = getHue(red: red, green: green, blue: blue)
                    let alpha: CGFloat = (hue >= fromHue && hue <= toHue) ? 0: 1
                    
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))
        
        let colorCubeFilter = CIFilter(
            name: "CIColorCube",
            parameters: ["inputCubeDimension": size, "inputCubeData": data])
        return colorCubeFilter
    }
    
    func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat
    {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
}
