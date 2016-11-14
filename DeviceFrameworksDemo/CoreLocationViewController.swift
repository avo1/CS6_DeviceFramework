//
//  ViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Harley Trung on 4/11/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CoreLocationViewController: UIViewController {
    lazy var locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("setting locationManager")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers //kCLLocationAccura
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 300
    }
    
}

extension CoreLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            print("start update location")
            locationManager.startUpdatingLocation()
//            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            print("location ", location)
        }
    }
}

