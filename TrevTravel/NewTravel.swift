//
//  NewTravel.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-18.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

class NewTravel: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newTitle: UITextView!
    @IBOutlet weak var newShortText: UITextView!
    @IBOutlet weak var contentTable: UITableView!
  
    var newTravelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newTravelData.dataDel = self // If needs DataDelegate class
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadContentData()
    }

    func loadContentTable() {
        contentTable.reloadData()
    }

    func loadContentData() {
        newTravelData.contentArray.removeAll()
//        contentData.loadDB()
        // Get content data
        newTravelData.content = ["Stadshuset", "Stadshuset2"]
        newTravelData.setContentArray(array: newTravelData.content)
        loadContentTable()
    }
    
    @IBAction func saveData() {
        newTravelData.newTravelInfo.author = "Shan"
        newTravelData.newTravelInfo.changedAt = ""
        newTravelData.newTravelInfo.coverImg = "Stadshuset"
        newTravelData.newTravelInfo.createdAt = "2018-09-22 22:22:32"
        newTravelData.newTravelInfo.likes = "0"
        newTravelData.newTravelInfo.place = "Vasagatan 22, Stockholm, Sweden"
        newTravelData.newTravelInfo.shortText = newShortText.text ?? ""
        newTravelData.newTravelInfo.title = newTitle.text ?? ""
        newTravelData.newTravelInfo.content = ["Stadshuset", "Stadshuset2"]

        // upload saved data to Firebase
        newTravelData.uploadData()
        
//        let db = Firestore.firestore()
//        let dataDict = [
//            "author": newTravelData.newTravelInfo.author,
//            "changedAt": "",
//            "content": newTravelData.newTravelInfo.content,
//            "coverImg": newTravelData.newTravelInfo.coverImg,
//            "createdAt": newTravelData.newTravelInfo.createdAt,
//            "likes": newTravelData.newTravelInfo.likes,
//            "place": newTravelData.newTravelInfo.place,
//            "shortText": newTravelData.newTravelInfo.shortText,
//            "title": newTravelData.newTravelInfo.title
//            ] as [String : Any]
//
//        db.collection("travelDiary").document().setData(dataDict) { err in
//            if let error = err {
//                print("Error uploading data to travelDiary: \(error)")
//            } else {
//                print("Document saved")
//                //                if self.oneRestaurant.img != nil { self.uploadImage(imgName: imgName) }
//            }
//        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTravelData.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
        let row = indexPath.row
        let contentCell = newTravelData.contentArray[row]
        cell.newImage?.image = UIImage(named:contentCell.image)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
