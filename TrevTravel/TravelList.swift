//
//  TravelList.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

class TravelList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var travelTable: UITableView!
    let travelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get data from the database of firebase
        let db = Firestore.firestore()
        db.collection("users").whereField("name", isEqualTo: "abc").getDocuments { (snapshot, error) in
            if error != nil {
                print(error ?? "error 1")
            } else {
                for document in (snapshot?.documents)! {
                    if let name = document.data()["name"] as? String {
                        if let age = document.data()["age"] as? Int {
                            print(name, age)
                        }
                    }
                    
                    
                }
            }
        }
        
        // Add data to database
        let name = "xyz"
        let age = 80
        let dict :[String : Any] = ["name": name, "age": age]
        
        // Add data with specific ID
        db.collection("users").document("newID").setData(dict)
        
        // Add data with random ID
        // db.collection("users").addDocument(data: dict)
        
        ///////////////////////////////////////////////////////////////////
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the amount of the section
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        let travelCell = travelData.travelArray[row]
        cell.titleLabel?.text = travelCell.title
        cell.travelImage?.image = UIImage(named: travelCell.coverImg)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
