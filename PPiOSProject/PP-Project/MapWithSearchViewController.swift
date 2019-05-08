//
//  MapWithSearchViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/7/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapWithSearchViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, UISearchControllerDelegate, MKLocalSearchCompleterDelegate {
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var resultSearchController: UISearchController? = nil
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var locationManage = CLLocationManager()
    
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
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! SearchResultsTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as? UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeThatFits(CGSize.init(width: 25, height: 30))
        searchBar.placeholder = "Enter your location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    
    //MARK;- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unnable to access your current location")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Ignoring User
        UIApplication.shared.beginIgnoringInteractionEvents()
//
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Create the search request
        matchingItems.removeAll()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        searchRequest.region = mapView.region

        let activeSearch = MKLocalSearch(request: searchRequest)
        
        // Start Search
        activeSearch.start(completionHandler: {(response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let results = response {
                
                if let err = error {
                    print("Error occurred in search: \(err.localizedDescription)")
                } else if results.mapItems.count == 0 {
                    print("no matches found")
                } else {
                    print("matches found")
                    
                    for item in results.mapItems {
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No match")")
                        
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                    
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })

    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be redacted
    }
    
}
// End of Class


