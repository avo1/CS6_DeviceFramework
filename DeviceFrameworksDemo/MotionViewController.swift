//
//  MotionViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Dave Vo on 3/21/17.
//  Copyright © 2017 coderschool.vn. All rights reserved.
//

import UIKit
import CoreMotion

class MotionViewController: UIViewController {

    var motionManager: CMMotionManager!
    var timer: Timer!
    
    @IBOutlet weak var shakeLabel: UILabel!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.becomeFirstResponder()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MotionViewController.update), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("bye bye")
        timer.invalidate()
    }
    
    func update() {
        if let accelerometerData = motionManager.accelerometerData {
            print("Accelerometer = \(accelerometerData)")
        }
//        if let gyroData = motionManager.gyroData {
//            print("Gyro = \(gyroData)")
//        }
//        if let magnetometerData = motionManager.magnetometerData {
//            print("Magneto = \(magnetometerData)")
//        }
        if let deviceMotion = motionManager.deviceMotion {
            print("Device motion = \(deviceMotion)")
        }
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            shakeLabel.text = "More and more"
        }
    }
}
