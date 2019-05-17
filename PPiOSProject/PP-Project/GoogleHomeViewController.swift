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

    @IBOutlet weak var mapScreenView: UIView!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var walletButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //menuBar UI settings
        menuBar.layer.shadowColor = UIColor.lightGray.cgColor
        menuBar.layer.shadowRadius = 8
        menuBar.layer.shadowOpacity = 1.0
        menuBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        menuBar.layer.backgroundColor = UIColor.white.cgColor
        walletButton.layer.shadowColor = UIColor.lightGray.cgColor
        walletButton.layer.shadowRadius = 8
        walletButton.layer.shadowOpacity = 1.0
        walletButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        walletButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        
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
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
//        let blueDot = UIImage(named: "bluedot")!.withRenderingMode(.alwaysTemplate)
//        let markerView = UIImageView(image: blueDot)
//        let marker = GMSMarker(position: camera.target)
//        marker.icon = GMSMarker.markerImage(with: .red)
//        marker.snippet = "Current location"
//        let degrees = 90.0
//        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//        marker.rotation = degrees
//        marker.map = mapView
//        marker.rotation = locationManager.location?.course ?? 0
        self.mapScreenView.addSubview(mapView)
        self.mapScreenView.addSubview(walletButton)

    }
    
   
    
    @IBAction func walletButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToWallet", sender: sender)
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
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        
    }
    
   

    
}
// End of Class
