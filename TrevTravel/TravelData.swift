//
//  TravelData.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

protocol DataDelegate {
    func loadTable()
    func loadData()
}

// Detail view
//protocol TravelDelegate {
//    func setTravelData()
//}

class TravelData {
    
    var dataDel: DataDelegate?
//    var travelDel: TravelDelegate?
    
    struct TravelInfo {
        // 9 fields
        var author = ""
        var changedAt = ""
        var content:Array<String> = []
        var coverImg = ""
        var createdAt = ""
        var likes = ""
        var place = ""
        var shortText = ""
        var title = ""
    }
    
    // Structure for content cell in content table
    struct Content {
        var image = ""
    }
    
    var travelArray:[TravelInfo] = []
    var contentArray:[Content] = [] 
    var content:Array<String> = [] // Save content's info when add a picture
    var newTravelInfo = TravelInfo()
   
    // Load data from Firebase. HOME
    func loadDB(){
        let db = Firestore.firestore()
        db.collection("travelDiary").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents of travelDiary: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                var aDiary = TravelInfo()
                for document in qSnapshot.documents {
//                    aDiary.id = document.documentID
                    aDiary.author = document.data()["author"] as? String ?? ""
                    aDiary.changedAt = document.data()["changedAt"] as? String ?? ""
                    aDiary.content = document.data()["content"] as? Array ?? []
                    aDiary.coverImg = document.data()["title"] as? String ?? ""
                    aDiary.createdAt = document.data()["createdAt"] as? String ?? ""
                    aDiary.likes = document.data()["likes"] as? String ?? ""
                    aDiary.place = document.data()["place"] as? String ?? ""
                    aDiary.shortText = document.data()["shortText"] as? String ?? ""
                    aDiary.title = document.data()["title"] as? String ?? ""
                    
                    self.travelArray.append(aDiary)
                    self.setContentArray(array: aDiary.content)
                }
                self.dataDel?.loadTable()
            }
        }
    }
    
    // Save content to contentArray after getting content from Firebase. ContentView
    func setContentArray(array: Array<String>){
        var newContent = Content()
        for element in array {
            newContent.image = element
            self.contentArray.append(newContent)
        }
    }
    
    // ContentView
    func saveContent(image:String){
        self.content.append(image)
    }
    
    func uploadData() {

        let db = Firestore.firestore()
        let dataDict = [
            "author": newTravelInfo.author,
            "changedAt": "",
            "content": newTravelInfo.content,
            "coverImg": newTravelInfo.coverImg,
            "createdAt": newTravelInfo.createdAt,
            "likes": newTravelInfo.likes,
            "place": newTravelInfo.place,
            "shortText": newTravelInfo.shortText,
            "title": newTravelInfo.title
            ] as [String : Any]
        
        db.collection("travelDiary").document().setData(dataDict) { err in
            if let error = err {
                print("Error uploading data to travelDiary: \(error)")
            } else {
                print("Document saved")
//                if self.oneRestaurant.img != nil { self.uploadImage(imgName: imgName) }
            }
        }
    }
    
//    init() {
//        var newContent = Content()
//        newContent.image = "Stadshuset"
//        contentArray.append(newContent)
//
//        newContent.image = "Stadshuset2"
//        contentArray.append(newContent)
//    The Stockholm City Hall is the building of the Municipal Council for the City of Stockholm in Sweden. It stands on the eastern tip of Kungsholmen island, next to Riddarfjärden's northern shore and facing the islands of Riddarholmen and Södermalm.
//    }
    
}
