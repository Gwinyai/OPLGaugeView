//
//

import UIKit

open class OPLGaugeLayer: CAShapeLayer {
    
    internal var disableSpringAnimation: Bool = true
    
    open override func action(forKey event: String) -> CAAction? {
        
        if event == "transform" && !disableSpringAnimation {
            
            let springAnimation = CASpringAnimation(keyPath: event)
            
            springAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            springAnimation.initialVelocity = 0.8
            
            springAnimation.damping = 1
            
            return springAnimation
            
        }
        
        return super.action(forKey: event)
        
    }
    
}
