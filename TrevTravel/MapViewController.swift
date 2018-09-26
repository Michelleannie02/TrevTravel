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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeBtn: UISegmentedControl!
    @IBOutlet weak var searchBarView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 59.347582, 18.110607
        let location = CLLocationCoordinate2DMake(59.347582, 18.110607)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        // Map type
        mapView.mapType = .satellite
        
        // get a pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Stockholm"
        mapView.addAnnotation(annotation)
        
        
    }
    
    @IBAction func swapMap(_ sender: UISegmentedControl) {
    }
    
    @IBOutlet weak var searchAdd: UISearchBar!
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    */

}
