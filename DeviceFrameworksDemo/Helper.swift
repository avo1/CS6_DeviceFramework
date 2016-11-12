//
//  Helper.swift
//  DeviceFrameworksDemo
//
//  Created by Dave Vo on 9/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func showAlertWithTitle(_ title:String, message:String, inViewController vc: UIViewController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        
        DispatchQueue.main.async { () -> Void in
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
