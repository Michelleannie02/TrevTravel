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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeBtn: UISegmentedControl!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        showMap()

        addSearchBarOnNavigationBar()
        
        let getlocation = stringToLocation("450 Washington St, Boston, MA 02111, USA")
        print("getlocation: \(getlocation.coordinate.latitude)")
    }
    
    
    func stringToLocation(_ address:String) -> CLLocation {
        
//        let address = "Malmvägen 1, 115 41 Stockholm"
        var returnLocation:CLLocation = CLLocation(latitude: 59.347582, longitude: 18.110607)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            returnLocation = location
            print("location: \(location.coordinate.latitude)")
            // Use your location
        }
        
        print("return: \(returnLocation.coordinate.latitude)")

        return returnLocation
    }
    
    func showMap() {
        // 59.347582, 18.110607
        let location = CLLocationCoordinate2DMake(59.347582, 18.110607)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        // Map type
        swapMap(mapTypeBtn)
        
        // get a pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Stockholm"
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
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.delegate = self as? UITextFieldDelegate
        self.view.addSubview(textField)
        
        navigationItem.titleView = textField
       
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
    
    }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    */

}
