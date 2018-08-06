//
//

import UIKit

@IBDesignable
open class OPLGaugeView: UIView {
    
    private lazy var gauge: OPLGaugeLayer = {
        
        let _gauge = OPLGaugeLayer()
        
        _gauge.drawsAsynchronously = true
        
        _gauge.disableSpringAnimation = true
        
        return _gauge
        
    }()
    
    @IBInspectable open var enableSpring: Bool {
        
        set {
            
            gauge.disableSpringAnimation = newValue
            
        }
        
        get {
            
            return gauge.disableSpringAnimation
            
        }
        
    }
    
    @IBInspectable open var displayMarkers: Bool = true {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var displayNumbers: Bool = true {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    
    @IBInspectable open var gaugeColor: UIColor = UIColor.orange {
        
        didSet {
            
            gauge.fillColor = gaugeColor.cgColor
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var markers: Int = 5 {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var minSpeed: CGFloat = 0 {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var maxSpeed: CGFloat = 25 {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var textFont: UIFont = UIFont.boldSystemFont(ofSize: 24) {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.black {
        
        didSet {
            
            setNeedsDisplay()
            
        }
        
    }
    
    @IBInspectable open var startingSpeed: CGFloat = 0 {
        
        didSet {
            
            if startingSpeed > maxSpeed {
                
                startingSpeed = maxSpeed
                
            }
            
            if startingSpeed < minSpeed {
                
                startingSpeed = minSpeed
                
            }
            
            setNeedsDisplay()
            
        }
        
    }
    
    private let lineWidth: CGFloat = 6
    
    open override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let radius = min(bounds.width, bounds.height) / 2
        
        let startAngle: CGFloat = 0.75 * CGFloat(Double.pi)
        
        let endAngle: CGFloat = 0.25 * CGFloat(Double.pi)
        
        let outlinePath = UIBezierPath(arcCenter: center, radius: radius - (lineWidth / 2), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        outlinePath.lineWidth = lineWidth
        
        gaugeColor.setStroke()
        
        outlinePath.stroke()
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        
        gaugeColor.setFill()
        
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        
        let arcLengthPerMark: CGFloat = angleDifference / CGFloat(markers)
        
        let multiplePerMark: CGFloat = (maxSpeed - minSpeed) / CGFloat(markers)
        
        let markerWidth: CGFloat = lineWidth - 1
        
        let markerSize: CGFloat = markerWidth * 2
        
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize).integral)
        
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 0...markers {
            
            context.saveGState()
            
            let angle = arcLengthPerMark * CGFloat(i) + startAngle - .pi / 2
            
            context.rotate(by: angle)
            
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            
            if displayMarkers {
            
                markerPath.fill()
                
            }
            
            context.rotate(by: CGFloat(Double.pi))
            
            let label = round(value: multiplePerMark * CGFloat(i) + minSpeed)
            
            let labelWidth = label.width(font: textFont)
            
            let textPos = CGPoint(x: -labelWidth / 2, y: 0)
            
            if displayNumbers {
            
                label.draw(at: textPos, withAttributes: [NSAttributedStringKey.font: textFont, NSAttributedStringKey.foregroundColor: textColor])
                
            }
            
            context.restoreGState()
            
        }
        
        context.restoreGState()
        
    }
    
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        gauge.fillColor = gaugeColor.cgColor
        
        layer.addSublayer(gauge)
        
        let anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        let newPoint = CGPoint(x: gauge.bounds.size.width * anchorPoint.x, y: gauge.bounds.size.height * anchorPoint.y)
        
        let oldPoint = CGPoint(x: gauge.bounds.size.width * gauge.anchorPoint.x, y: gauge.bounds.size.height * gauge.anchorPoint.y)
        
        var position = gauge.position
        
        position.x -= oldPoint.x
        
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        
        position.y += newPoint.y
        
        gauge.position = position
        
        gauge.anchorPoint = anchorPoint
        
        rotateGauge(newSpeed: startingSpeed)
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewWidth = frame.width
        
        let halfViewWidth = viewWidth / 2
        
        let viewHeight = frame.height
        
        let gaugeYPos: CGFloat = viewHeight * 0.05
        
        let gaugeHeight: CGFloat = viewHeight * 0.45
        
        let gaugeWidth: CGFloat = gaugeHeight * 0.16
        
        let gaugeFrame = CGRect(x: halfViewWidth - (gaugeWidth / 2), y: gaugeYPos, width: gaugeWidth, height: gaugeHeight).integral
        
        gauge.bounds.size = gaugeFrame.size
        
        gauge.position.x = gaugeFrame.origin.x + (gaugeFrame.width / 2)
        
        gauge.position.y = gaugeFrame.origin.y + gaugeFrame.height
        
        let gaugePath = UIBezierPath()
        
        gaugePath.move(to: CGPoint(x: gaugeWidth / 2, y: 0))
        
        gaugePath.addLine(to: CGPoint(x: gaugeWidth, y: gaugeHeight))
        
        gaugePath.addLine(to: CGPoint(x: 0, y: gaugeHeight))
        
        gaugePath.close()
        
        gauge.path = gaugePath.cgPath
        
    }
    
    func rotateGauge(newSpeed: CGFloat) {
        
        var speed = newSpeed
        
        if speed > maxSpeed {
            
            speed = maxSpeed
            
        }
        
        if speed < minSpeed {
            
            speed = minSpeed
            
        }
        
        let fractalSpeed = (speed - minSpeed) / (maxSpeed - minSpeed)
        
        let newAngle = 0.75 * CGFloat(Double.pi) * (2 * fractalSpeed - 1)
        
        gauge.transform = CATransform3DMakeRotation(newAngle, 0, 0, 1)
        
    }
    
    private func round(value: CGFloat) -> String {
        
        let divisor = pow(10, Double(1))
        
        let roundedNumber = (Double(value) * divisor).rounded() / divisor
        
        if roundedNumber.isZero {
            
            return "0"
            
        }
        
        let intRoundedNumber = Int(roundedNumber)
        
        if Double(intRoundedNumber) == roundedNumber {
            
            return "\(intRoundedNumber)"
            
        }
        
        return "\(roundedNumber)"
        
    }

}

fileprivate extension String {
    
    func width(font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: CGFloat(220))

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
        
    }
    
}
