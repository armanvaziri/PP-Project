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

extension UITextField {
    func setPadding() {
        let cgrt = CGRect(x: 0, y: 0, width: 10, height: self.frame.height)
        let paddingView = UIView(frame: cgrt)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.blue.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class GoogleHomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    // Variables
    var cardImages = ["card2", "card3", "card4", "card5", "card1"]
    let locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    let infoMarker = GMSMarker()
    var cardTableView = UITableView()
    var transparentView = UIView()
    var nearbyPlaces: [String] = []
    var nearbyPlacesTypes: [[String]] = []
    var selectedPlaceTypes: [String] = []
    
    // Outlets
    @IBOutlet weak var mapScreenView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.setPadding()
        self.textField.setBottomBorder()
        cardTableView.isScrollEnabled = true
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(CardMenuCell.self, forCellReuseIdentifier: "Cell")
        mainUI()
        locationManagerStart()
    }
    
    // UI Customizationn
    
    func mainUI() {
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        lowerView.layer.shadowColor = UIColor.lightGray.cgColor
        lowerView.layer.shadowRadius = 10.0
        lowerView.layer.shadowOpacity = 0.75
        lowerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        lowerView.backgroundColor = UIColor.white
        
    }

    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
    // Present the Autocomplete View Controller when the textField is tapped.
    
    @IBAction func textFieldTapped(_ sender: Any) {
        textField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
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
        nearbyPlaces(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
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
    
    // Recognizes tap on a POI, creates a marker displaying information, reveals/returns card recommendation window
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
                self.selectedPlaceTypes.removeAll()
                
                for type in place.types! {
                    typeString.append("\(type), ")
                    self.selectedPlaceTypes.append(type)
                }
                self.infoMarker.snippet = self.selectedPlaceTypes[0]
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
        cardRecommendationMenu()
    }
 
    // Obtain the names and details of nearby locations
    // Used for collection view
    func nearbyPlaces(latitude: Double, longitude: Double) {
        //add paramaters here to change nearby location results
        let jsonUrlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=25&keyword=store&key=AIzaSyAZJF1h5cRNnJiW2IkfabKchWpbWkn40HA"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, respone, err) in
            guard let data = data else { return }
            if self.nearbyPlaces.count == 0 {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                    if let results = json["results"] as! [[String: Any]]? {
                        let resultsCount = results.count
                        var counter = 0
                        while counter < resultsCount {
                            let index = results[counter]
                            let name = index["name"] as! String
                            let types = index["types"] as! [String]
                            self.nearbyPlaces.append(name)
                            self.nearbyPlacesTypes.append(types)
                            counter += 1
                        }
                    }
                    print("!!! LOOK HERE FOR NEARBY PLACES!!!")
                    print(self.nearbyPlaces)
                    print(self.nearbyPlacesTypes)
                } catch let jsonErr {
                    print("json error:", jsonErr)
                }
            }
        }.resume()
        collectionView.reloadData()
    }
    
    // Loads the map based on selected PLACE from SEARCH
    func loadMapView(place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 19.5)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.mapScreenView.frame.width, height: self.mapScreenView.frame.height), camera: camera)
        
        mapView.delegate = self
        
        // Google Maps styling wizard
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
        createInfoMarker(mapView: mapView, place: place)
    }
    
    // Creates and places an info marker for the given place onto the map
    func createInfoMarker(mapView: GMSMapView, place: GMSPlace) {
        mapView.isMyLocationEnabled = true
        let location = place.coordinate
        let marker = GMSMarker()
        marker.title = place.name
        marker.snippet = self.selectedPlaceTypes[0]
        marker.position = location
        marker.opacity = 0
        marker.infoWindowAnchor.y = 0.5
        marker.appearAnimation = .pop
        marker.layer.backgroundColor = UIColor.red.cgColor
        marker.map = mapView
        mapView.selectedMarker = marker
        self.mapScreenView.addSubview(mapView)
        cardRecommendationMenu()
        
    }
    
    // Nearby locations CollectionView delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nearbyPlaces.count < 10 {
            return nearbyPlaces.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! POICollectionViewCell
        
        if nearbyPlaces.count > 0 {
            cell.name.text = nearbyPlaces[indexPath.row]
            cell.locationDetails.text = nearbyPlacesTypes[indexPath.row][0]
        } else {
            cell.name.text = "unable to load"
            cell.name.text = "unable to load"
        }
        return cell
    }
    
    // Brings up a tableView of cards based on user-selected location
    func cardRecommendationMenu() {
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
    
    // Recognizes tap on screen, return card recommendation menu
    @objc func clickOnScreen() {
        let screenSize = UIScreen.main.bounds.size
        
        // Card menu return animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.cardTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 375)
        }, completion: nil)
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

extension GoogleHomeViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        textField.text = place.name
        self.selectedPlaceTypes.removeAll()
        self.selectedPlaceTypes = place.types!
        loadMapView(place: place)
        
        // Dismiss the GMSAutocompleteViewController when a place is selected
        dismiss(animated: true, completion: nil)
       
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
