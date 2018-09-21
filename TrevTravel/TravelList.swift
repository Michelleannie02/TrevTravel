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
    
    var travelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all the travel diaries data from Firebase
        print("in viewDidLoad.")
        travelData.loadDB()
        print("viewDidLoad, travelData.travelArray: ",travelData.travelArray.count)
        
//        let db = Firestore.firestore()
//        db.collection("travelDiary").getDocuments { (querySnapshot, error) in
//            if let err = error {
//                print("Error getting documents from travelDiary: \(err)")
//            } else {
//                guard let qSnapshot = querySnapshot else {return}
//                for document in qSnapshot.documents {
//                    let id = document.documentID
//                    let author = document.data()["author"] as? String ?? ""
//                    let changedAt = document.data()["changedAt"] as? String ?? ""
//                    let coverImg = document.data()["title"] as? String ?? ""
//                    let createdAt = document.data()["createdAt"] as? String ?? ""
//                    let likes = document.data()["likes"] as? String ?? ""
//                    let place = document.data()["place"] as? String ?? ""
//                    let shortText = document.data()["shortText"] as? String ?? ""
//                    let title = document.data()["title"] as? String ?? ""
//                    let contentArray = document.data()["content"] as? Array ?? []
//                    print(id,author,changedAt,coverImg,createdAt,likes,place,shortText,title,contentArray)
////                    print(id, author)
//                }
//            }
//        }
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the amount of the section
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        let travelCell = travelData.travelArray[row]
        cell.titleLabel?.text = travelCell.title
        cell.createdAtLabel?.text = travelCell.createdAt
        cell.travelImage?.image = UIImage(named: travelCell.coverImg)
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
