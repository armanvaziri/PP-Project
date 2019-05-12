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

class GoogleHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var mapScreenView: UIView!
    
    
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Button UI settings
        orangeButton.layer.cornerRadius = orangeButton.frame.height / 2
        purpleButton.layer.cornerRadius = purpleButton.frame.height / 2
        blueButton.layer.cornerRadius = blueButton.frame.height / 2
        orangeButton.layer.shadowColor = UIColor.lightGray.cgColor
        orangeButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        orangeButton.layer.shadowRadius = 5
        orangeButton.layer.shadowOpacity = 1.0
        purpleButton.layer.shadowColor = UIColor.lightGray.cgColor
        purpleButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        purpleButton.layer.shadowRadius = 5
        purpleButton.layer.shadowOpacity = 1.0
        blueButton.layer.shadowColor = UIColor.lightGray.cgColor
        blueButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        blueButton.layer.shadowRadius = 5
        blueButton.layer.shadowOpacity = 1.0
        
        
        
        orangeButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        purpleButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        blueButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
    }
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 19.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.mapScreenView.frame.width, height: self.mapScreenView.frame.height), camera: camera)
        mapView.delegate = self
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.isDraggable = true
        marker.map = mapView
        self.mapScreenView.addSubview(mapView)
        self.mapScreenView.addSubview(orangeButton)
        self.mapScreenView.addSubview(purpleButton)
        self.mapScreenView.addSubview(blueButton)
    }
    
    
    
    let infoMarker = GMSMarker()
    
    //Recognizes tap on POI and creates a marker displaying information
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        infoMarker.title = name
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.types.rawValue))!
        
        let placesClient = GMSPlacesClient.shared()
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {(place: GMSPlace?, error: Error?) in
            if error != nil {
                print("ERROR OCCURRED: \(error?.localizedDescription)")
                return
            }
            if let place = place {
                print("UPDATING PLACE")
                self.infoMarker.title = place.name
                var typeString = ""
                for type in place.types! {
                    typeString.append(" \(type)")
                }
                self.infoMarker.snippet = typeString
                mapView.selectedMarker = self.infoMarker
            }
        })

        infoMarker.position = location
        infoMarker.opacity = 0;
        infoMarker.iconView?.backgroundColor = UIColor.red
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        
    }
    
   

    
}
// End of Class
