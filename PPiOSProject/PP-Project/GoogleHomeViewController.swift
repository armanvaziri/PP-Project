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
    
    
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        let theMap = GMSMapView()
        theMap.settings.myLocationButton = true
        let camera = GMSCameraPosition()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
    }
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 20.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), camera: camera)
        mapView.delegate = self
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.isDraggable = true
        marker.map = mapView
        self.view.addSubview(mapView)
    }
    
    let infoMarker = GMSMarker()
    
    //Recognizes tap on POI and creates a marker displaying information
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        infoMarker.title = name
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        
        //For displaying extended place information (ex: types)
        
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
        
    }
    
   

    
}
// End of Class
