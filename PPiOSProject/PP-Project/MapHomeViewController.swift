//
//  MapHomeViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/8/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapHomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
    
        } else {
            print("Please enable location services or GPS")
        }
    }
    
    //MARK:- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
        self.mapView.setRegion(region, animated: true)
        
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

}
