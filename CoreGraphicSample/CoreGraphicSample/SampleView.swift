//
//  SampleView.swift
//  CoreGraphicSample
//
//  Created by Quang Tran on 2/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class SampleView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
//        1. Fill background color
        ctx.setFillColor(UIColor.green.cgColor)
        ctx.fill(rect)
        
//        2. Fill an ellipse
//        ctx.setFillColor(UIColor.red.cgColor)
//        ctx.fillEllipse(in: CGRect(x: 0, y: 0, width: 300, height: 300))

//        Fill an ellipse
//        ctx.setFillColor(UIColor.red.cgColor)
//        ctx.addEllipse(in: CGRect(x: 0, y: 0, width: 300, height: 300))
//        ctx.fillPath()
        
//        3. Fill a path
//        ctx.setFillColor(UIColor.red.cgColor)
//        ctx.addLine(to: CGPoint(x: 100, y: 50))
//        ctx.beginPath()
//        ctx.move(to: CGPoint(x: 0, y: 0))
//        ctx.addLine(to: CGPoint(x: 300, y: 0))
//        ctx.addLine(to: CGPoint(x: 300, y: 300))
//        ctx.closePath()
//        ctx.fillPath()

//        4. Fill an arc
//        ctx.setFillColor(UIColor.red.cgColor)
//        ctx.move(to: CGPoint(x: 150, y: 150))
//        ctx.addArc(center: CGPoint(x: 150, y: 150),
//                   radius: 150,
//                   startAngle: 0.0,
//                   endAngle: 270.0 * CGFloat.pi / 180.0,
//                   clockwise: false)
//        ctx.fillPath()
        
//        5. Stroke a curve
//        ctx.setStrokeColor(UIColor.red.cgColor)
//        ctx.setLineWidth(10)
//        ctx.move(to: CGPoint(x: 0, y: 150))
//        ctx.addCurve(to: CGPoint(x: 300, y: 150),
//                     control1: CGPoint(x: 75, y: 0),
//                     control2: CGPoint(x: 225, y: 300))
//        ctx.strokePath()

//        6. Draw a linear gradient
//        let gradient = CGGradient(colorsSpace: nil,
//                                  colors: [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray,
//                                  locations: nil)
//        ctx.drawLinearGradient(gradient!,
//                               start: CGPoint(x: 0, y: 0),
//                               end: CGPoint(x: 300, y: 300),
//                               options: [])
        
//        7. Draw a radial gradient
//        let gradient = CGGradient(colorsSpace: nil,
//                                  colors: [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray,
//                                  locations: nil)
//        ctx.drawRadialGradient(gradient!,
//                               startCenter: CGPoint(x: 150, y: 150),
//                               startRadius: 75,
//                               endCenter: CGPoint(x: 150, y: 150),
//                               endRadius: 150,
//                               options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        
        
    }

}
