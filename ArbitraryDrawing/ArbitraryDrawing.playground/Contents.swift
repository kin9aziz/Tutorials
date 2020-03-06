import UIKit

// 1. Fill background color
class View1: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.fill(rect)
  }
  
}

View1(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

// 2. Fill an Ellipse
class View2: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.addEllipse(in: bounds)
    ctx.fillPath()
  }
  
}

View2(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

// 3. Fill a Path
class View3: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: 0, y: 0))
    ctx.addLine(to: CGPoint(x: 200, y: 0))
    ctx.addLine(to: CGPoint(x: 200, y: 200))
    ctx.closePath()
    ctx.fillPath()
  }
  
}

View3(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

//4. Fill an Arc
class View4: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor.red.cgColor)
    ctx.move(to: CGPoint(x: 100, y: 100))
    ctx.addArc(
      center: CGPoint(x: 100, y: 100),
      radius: 100,
      startAngle: 0.0,
      endAngle: 270.0 * CGFloat.pi / 180.0,
      clockwise: false)
    ctx.fillPath()
  }
  
}

View4(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

// 5. Stroke a Curve
class View5: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setStrokeColor(UIColor.red.cgColor)
    ctx.setLineWidth(10)
    ctx.move(to: CGPoint(x: 0, y: bounds.height / 2))
    ctx.addCurve(
      to: CGPoint(x: bounds.width, y: bounds.height / 2),
      control1: CGPoint(x: bounds.width / 4, y: 0),
      control2: CGPoint(x: bounds.width * 3 / 4, y: bounds.height))
    ctx.strokePath()
  }
  
}

View5(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

// 6. Draw a Linear Gradient
class View6: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    let gradient = CGGradient(
      colorsSpace: nil,
      colors: [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray,
      locations: nil)
    ctx.drawLinearGradient(
      gradient!,
      start: CGPoint(x: 0, y: 0),
      end: CGPoint(x: bounds.width, y: bounds.height),
      options: [])
  }
  
}

View6(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

//7. Draw a Radial Gradient
class View7: UIView {
  
  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()!
    let gradient = CGGradient(
      colorsSpace: nil,
      colors: [UIColor.red.cgColor, UIColor.blue.cgColor] as CFArray,
      locations: nil)
    ctx.drawRadialGradient(
      gradient!,
      startCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
      startRadius: bounds.width / 4,
      endCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
      endRadius: bounds.width,
      options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
  }
  
}

View7(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
