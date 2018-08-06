//
//  ViewController.swift
//  OPLGaugeViewExample
//

import UIKit

import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var gaugeView: OPLGaugeView!
    
    var currentSpeed = 0.0
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let speed = manager.location?.speed {
            
            let speedInKmsHr = speed * 3.6
            
            self.gaugeView.rotateGauge(newSpeed: CGFloat(speedInKmsHr))
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
        
    }


}

