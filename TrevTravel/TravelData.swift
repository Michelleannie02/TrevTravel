//
//  TravelData.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TravelData {
    
    struct TravelInfo {
        // 9 fields
        var author = ""
        var changedAt = ""
        var contentArray:Array<String> = []
        var coverImg = ""
        var createdAt = ""
        var likes = ""
        var place = ""
        var shortText = ""
        var title = ""
    }
    
    var travelArray:[TravelInfo] = []
    
//    init() {
//        var newNote = TravelInfo()
//        newNote.title = "Drottningholm"
//        newNote.coverImg = "Drottningholm"
//        newNote.shortText = "The Drottningholm Palace (Swedish: Drottningholms slott) is the private residence of the Swedish royal family. It is located in Drottningholm."
//        newNote.likes = "3"
//        newNote.place = "Drottningholm 22, Stockholm, Sweden"
//        newNote.author = "Yangshan"
//        newNote.createdAt = "2018-09-17"
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//
//        newNote.title = "Stadshuset"
//        newNote.coverImg = "Stadshuset"
//        newNote.shortText = "The Stockholm City Hall is the building of the Municipal Council for the City of Stockholm in Sweden. It stands on the eastern tip of Kungsholmen island, next to Riddarfjärden's northern shore and facing the islands of Riddarholmen and Södermalm"
//        newNote.likes = "1"
//        newNote.place = "Vasagatan 22, Stockholm, Sweden"
//        newNote.author = "Yangshan"
//        newNote.createdAt = "2018-09-17"
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//        travelArray.append(newNote)
//    }
   
    func loadDB(){
        let db = Firestore.firestore()
        db.collection("travelDiary").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents from travelDiary: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                var newDiary = TravelInfo()
                for document in qSnapshot.documents {
//                    newDiary.id = document.documentID
                    newDiary.author = document.data()["author"] as? String ?? ""
                    newDiary.changedAt = document.data()["changedAt"] as? String ?? ""
                    newDiary.contentArray = document.data()["content"] as? Array ?? []
                    newDiary.coverImg = document.data()["title"] as? String ?? ""
                    newDiary.createdAt = document.data()["createdAt"] as? String ?? ""
                    newDiary.likes = document.data()["likes"] as? String ?? ""
                    newDiary.place = document.data()["place"] as? String ?? ""
                    newDiary.shortText = document.data()["shortText"] as? String ?? ""
                    newDiary.title = document.data()["title"] as? String ?? ""
                    print("qSnapshot:",newDiary.author,newDiary.changedAt,newDiary.coverImg,newDiary.createdAt,newDiary.likes,newDiary.place,newDiary.shortText,newDiary.title,newDiary.contentArray,newDiary.contentArray.count)
                    
                    self.travelArray.append(newDiary)
                }
                print("TravelData class:",self.travelArray,self.travelArray.count)
            }
        }
    }
    
}
