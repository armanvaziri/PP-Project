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

class GoogleHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    // Variables
    var images = ["store1", "store2", "store3", "store4", "store5", "store6"]
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    let infoMarker = GMSMarker()
    
    // Outlets from view
    @IBOutlet weak var mapScreenView: UIView!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var walletImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMagGlass: UIImageView!
    @IBOutlet weak var searchButtonText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // UI customizations
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
      
        walletButton.layer.shadowColor = UIColor.lightGray.cgColor
        walletButton.layer.shadowRadius = 8
        walletButton.layer.shadowOpacity = 1.0
        walletButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        walletButton.backgroundColor = UIColor.white
        walletButton.layer.cornerRadius = walletButton.frame.height / 2.0
        walletButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
        walletButton.addSubview(walletImage)
        
        searchButton.backgroundColor = UIColor.white
        searchButton.layer.cornerRadius = 15
        searchButton.layer.shadowColor = UIColor.lightGray.cgColor
        searchButton.layer.shadowRadius = 4.0
        searchButton.layer.shadowOpacity = 1.0
        searchButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.25)
        searchButton.layer.cornerRadius = 20.0
        
        // LocationManager set up
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    // Pulse animation
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    // LocationManager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
    }
    
    // Show current location on GoogleMap
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
        
        // Add all objects to mapScreenView progamatically or they won't show
        self.mapScreenView.addSubview(mapView)
//        self.mapScreenView.addSubview(walletButton)
//        self.mapScreenView.addSubview(walletImage)
        self.mapScreenView.addSubview(collectionView)
        self.mapScreenView.addSubview(searchButton)
        self.mapScreenView.addSubview(searchMagGlass)
        self.mapScreenView.addSubview(searchButtonText)
        
    }
    
    
    // Segueues
    @IBAction func walletButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToWallet", sender: sender)
    }
    
    //Recognizes tap on a POI and creates a marker displaying information
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
    
    //MARK: UITextFieldDelegate
    
    
    // CollectionView delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! POICollectionViewCell
        
        cell.cellImage.image = UIImage(named: images[indexPath.row])
        
        return cell
    }

    
}
// End of Class
