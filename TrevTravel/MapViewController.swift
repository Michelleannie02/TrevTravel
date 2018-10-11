//
//  MapViewController.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-26.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeBtn: UISegmentedControl!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // textField is added programlly
    @IBOutlet weak var searchTextField: UITextField!
    
    let userDefault = UserDefaults.standard
    var address:String = ""
    var myLocation:CLLocation = CLLocation(latitude: 59.347582, longitude: 18.110607)
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBarOnNavigationBar()
        self.locationManager.requestWhenInUseAuthorization()
        
        findMyLocation()
        
        // show map of post address
        let postAddress:String = userDefault.string(forKey: "showMap") ?? ""
        if postAddress != "" {
            address = postAddress
        }
        // address = "Stortorget 2, 103 16 Stockholm"
        // Receive data from segue
        if searchTextField != nil || address != "" {
            searchTextField.text = address
            print(textFieldShouldReturn(searchTextField)) // DO NOT DELETE
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        userDefault.set("", forKey: "showMap")
        userDefault.set("", forKey: "returnAddress")
    }
    
    func stringToLocation(_ address:String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            // Use your location
            print("location2: \(location.coordinate.latitude)")
            
            // showMap
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.showMap(latitude, longitude)
            
            
        }
        
        
    }
    
    func showMap(_ latitude:Double, _ longitude:Double) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        // Map type
        swapMap(mapTypeBtn)
        
        // get a pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = ""
        mapView.addAnnotation(annotation)
    }
    
    func addSearchBarOnNavigationBar() {
        // Get screen width
        let screenWidth = UIScreen.main.bounds.width
        print("screenWidth: \(screenWidth)")
        let searchBarWidth = screenWidth * 0.67

        // Add search bar on navigation bar
        let navigation = self.navigationController?.navigationBar
        navigation?.barStyle = UIBarStyle.default
        navigation?.tintColor = UIColor.gray
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: 32))
        textField.placeholder = "Enter address"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.search
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.delegate = self

        searchTextField = textField
        self.view.addSubview(searchTextField)

        navigationItem.titleView = searchTextField
        print("addSearchBarOnNavigationBar")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            
            let inPutAddress = searchTextField.text ?? ""
            print(inPutAddress)

            if inPutAddress != "" {
                stringToLocation(inPutAddress)
            }

            textField.resignFirstResponder()
            return false
        }
        return true
    }
    

    
    
    @IBAction func swapMap(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
    
    @IBAction func doneSearch(_ sender: Any) {
        var addressText = ""
        let returnAdd:String = self.searchTextField.text ?? ""

        if returnAdd.contains(",") {
            addressText = returnAdd.getSubString(of: ",")
        }

        self.userDefault.set(addressText, forKey: "returnAddress")
        print("Saved info: \(addressText)")
        // 返回
        self.navigationController?.popViewController(animated: false)
    }
    

    
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        let newLocation = locations[0]
//        print(newLocation)
//        let distance = myLocation.distance(from: newLocation)
//        if distance > 10 {
//            myLocation = newLocation
//        }
        
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("location = \(locValue.latitude) \(locValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 600, 600)
        self.mapView.setRegion(viewRegion, animated: true)
//        manager.stopUpdatingLocation()
        
    }
    
    @IBAction func navigation(_ sender: Any) {
        findMyLocation()
        print("navigation")
    }
    
   
}


extension String {
    func getSubString(of char: Character) -> String {
        guard let pos = self.range(of: String(char)) else { return self }
        // or  guard let pos = self.index(of: char) else { return self }
        let subString = self[..<pos.lowerBound]
        return String(subString)
    }
}

