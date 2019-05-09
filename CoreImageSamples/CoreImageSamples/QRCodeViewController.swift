//
//  BarcodeViewController.swift
//  CoreImageSamples
//
//  Created by Quang Tran on 2/15/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateQRCodeImage()
        detectQRCode()
    }
    
    func generateQRCodeImage() {
        let message = "Hello World"
        let data = message.data(using: String.Encoding.ascii)
        let qrCodeGeneratorFilter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data!])!
        
        let barcodeImage = UIImage(ciImage: qrCodeGeneratorFilter.outputImage!)
        self.imageView.image = barcodeImage
        
        // You need to upscale your generated QR code image to imageview's size
        // using nearest which results in sharp, pixelated image.
        // This usually isn't what you want when resizing icons/photos but is perfect for QR codes.
        self.imageView.layer.magnificationFilter = CALayerContentsFilter.nearest
    }
    
    func detectQRCode() {
        let inputImage = CIImage(cgImage: UIImage(named: "qrcode")!.cgImage!)
        let detector = CIDetector(ofType: "CIDetectorTypeQRCode", context: nil, options: nil)!
        let features = detector.features(in: inputImage)
        let qrCodeFeature = features.first as! CIQRCodeFeature
        self.messageLabel.text = qrCodeFeature.messageString!
    }
}
