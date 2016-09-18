//
//  AuthenticationViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Dave Vo on 9/17/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        let authenticationContext = LAContext()
        var err: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &err) else {
            
            Helper.showAlertWithTitle("Error", message: "No touchID found", inViewController: self)
            return
            
        }
        
        authenticationContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "bahlah") { (success, error) in
            if success {
                // Fingerprint recognized
                Helper.showAlertWithTitle("Welcome", message: "Login successfully", inViewController: self)
            } else {
                // Check if there is an error
                if let error = error {
                    Helper.showAlertWithTitle("Ehh!", message: error.localizedDescription, inViewController: self)
                }
            }
        }
    }
    
    
}
