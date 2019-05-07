//
//  HomePageViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/6/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import MapKit

class HomePageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManage = CLLocationManager()
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var homeRemotePanel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManage.requestWhenInUseAuthorization()
            }
            locationManage.desiredAccuracy = 1.0
            locationManage.delegate = self
            locationManage.startUpdatingLocation()
        } else {
            print("Please enable location services or GPS")
        }
      
                homeRemotePanel.layer.shadowRadius = 4.0
        homeRemotePanel.layer.shadowOpacity = 0.5
        homeRemotePanel.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    //MARK;- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.0020, longitudeDelta: 0.0020))
        self.mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unnable to access your current location")
    }
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    

}
