//
//  TravelList.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
//import Firebase

class TravelList: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDelegate{
    
    @IBOutlet weak var travelTable: UITableView!
    
    var travelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Get all the travel diaries data from Firebase
        travelData.dataDel = self
        
        // Get data from the database of firebase
//        let db = Firestore.firestore()
//        db.collection("users").whereField("name", isEqualTo: "abc").getDocuments { (snapshot, error) in
//            if error != nil {
//                print(error ?? "error 1")
//            } else {
//                for document in (snapshot?.documents)! {
//                    if let name = document.data()["name"] as? String {
//                        if let age = document.data()["age"] as? Int {
//                            print(name, age)
//                        }
//                    }
//                }
//            }
//        }
        
        // Add data to database
//        let name = "xyz"
//        let age = 80
//        let dict :[String : Any] = ["name": name, "age": age]
//
        // Add data with specific ID
//        db.collection("users").document("newID").setData(dict)
        
        // Add data with random ID
        // db.collection("users").addDocument(data: dict)
        
        ///////////////////////////////////////////////////////////////////
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadTable() {
        travelTable.reloadData()
        //        loadActivity.isHidden = true
    }
    
    // Get all the travel diaries data from Firebase
    func loadData() {
        travelData.travelArray.removeAll()
        travelData.loadDB() // Get data from Firebase
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        let travelCell = travelData.travelArray[row]
//        print("Travel List tabelView:",travelData.travelArray[row],travelData.travelArray[row].coverImgUrl,travelData.travelArray.count)
        cell.titleLabel?.text = travelCell.title
        cell.createdAtLabel?.text = travelCell.createdAt
//        cell.travelImage?.image = UIImage(named: travelCell.coverImgUrl) // When travelCell.coverImgUrl is local image
        cell.travelImage?.image = travelCell.coverImg
        cell.shortTextLabel?.text = travelCell.shortText
        cell.likesLabel?.text = travelCell.likes
        cell.placeLabel?.text = travelCell.place
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
