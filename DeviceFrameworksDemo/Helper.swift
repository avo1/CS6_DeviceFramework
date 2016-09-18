//
//  Helper.swift
//  DeviceFrameworksDemo
//
//  Created by Dave Vo on 9/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func showAlertWithTitle(title:String, message:String, inViewController vc: UIViewController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            vc.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
}
