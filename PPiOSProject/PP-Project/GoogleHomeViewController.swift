//
//  GoogleHomeViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/10/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import GoogleUtilities

class GoogleHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        let mapView = GMSMapView()
        let camera = GMSCameraPosition()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 17.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), camera: camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
        self.view.addSubview(mapView)
    }
    

}
