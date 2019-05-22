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

class GoogleHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var images = ["store1", "store2", "store3", "store4", "store5", "store6"]
    var cardImages = ["card2", "card3", "card4", "card5", "card1"]
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    let infoMarker = GMSMarker()
    var cardTableView = UITableView()
    var transparentView = UIView()
    
    // Outlets
    @IBOutlet weak var mapScreenView: UIView!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMagGlass: UIImageView!
    @IBOutlet weak var searchButtonText: UILabel!
    @IBOutlet weak var lowerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardTableView.isScrollEnabled = true
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(CardMenuCell.self, forCellReuseIdentifier: "Cell")
        mainViewUI()
        searchButtonUI()
        locationManagerStart()
        lowerView.backgroundColor = UIColor.white
        
    }
    
    // UI Customizationn
    
    func mainViewUI() {
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
    }

    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    func searchButtonUI() {
        searchButton.layer.cornerRadius = 2
//        searchButton.layer.shadowColor = UIColor.lightGray.cgColor
//        searchButton.layer.shadowRadius = 4.0
//        searchButton.layer.shadowOpacity = 1.0
//        searchButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.25)
//        searchButton.layer.cornerRadius = 20.0
        lowerView.layer.shadowColor = UIColor.lightGray.cgColor
        lowerView.layer.shadowRadius = 10.0
        lowerView.layer.shadowOpacity = 1.0
        lowerView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
    }
    
    // LocationManager delegates
    
    func locationManagerStart() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
    }
    
    // Show current location on GoogleMap
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 19.5)

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
        
        // IMPORTANT: Add all objects (that sit on the map) to mapScreenView progamatically or they won't show
        self.mapScreenView.addSubview(mapView)
        
    }
    
    // Recognizes tap on a POI: creates a marker displaying information, reveals/returns card recommendation window
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        infoMarker.title = name

        // Specify the place data types to return
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.types.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
        
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
                    typeString.append("\(type), ")
                }
                self.infoMarker.snippet = typeString
                mapView.selectedMarker = self.infoMarker
            }
        })
        
        // Zooms on tapped POI and places infomarker
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 19.5)
        infoMarker.position = location
        infoMarker.opacity = 0
        infoMarker.infoWindowAnchor.y = 0.5
        infoMarker.appearAnimation = .pop
        infoMarker.layer.backgroundColor = UIColor.red.cgColor
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
        
        // Brings up a transparentView that recognizes taps to return the card recommendation menu
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.clear
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        // Creates tap gesture for clicking on transparentView & returning the card menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickOnScreen))
        transparentView.addGestureRecognizer(tapGesture)
        
        // Adds card menu to the view
        let screenSize = UIScreen.main.bounds.size
        cardTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 375)
        window?.addSubview(cardTableView)
        
        transparentView.alpha = 0
        
        // Card menu appearance animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.cardTableView.frame = CGRect(x: 0, y: screenSize.height - 375, width: screenSize.width
                , height: 375)
        }, completion: nil)
    }
    
    // Returns menu after tap on map
    @objc func clickOnScreen() {
        
        let screenSize = UIScreen.main.bounds.size
        
        // Card menu return animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.cardTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 375)
        }, completion: nil)
        
    }

    
    // Segueues
    
    @IBAction func walletButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToWallet", sender: sender)
    }
    
    // Nearby locations CollectionView delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! POICollectionViewCell
        
        cell.cellImage.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    // Card recommendation menu TableView delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CardMenuCell else {fatalError("unable to deque cell")}
        // This is all hardcoded, implement credit card data here
        cell.nameLabel.text = "Bank name"
        cell.nameLabel.textColor = UIColor.lightGray
        cell.name2Label.text = "Card name"
        cell.name2Label.textColor = UIColor.black
        cell.name3Label.text = "Card provider"
        cell.name3Label.textColor = UIColor.lightGray
        cell.cardImage.image = UIImage(named: cardImages[indexPath.row])
        cell.rewardLabel.text = "Top reward here"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
// End of Class
