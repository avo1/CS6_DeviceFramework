//
//  NotiViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Dave Vo on 3/20/17.
//  Copyright © 2017 coderschool.vn. All rights reserved.
//

import UIKit

class NotiViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSet(_ sender: UIButton) {
        let selectedDate = datePicker.date
        print("Selected date: \(selectedDate)")
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate)
    }

}
