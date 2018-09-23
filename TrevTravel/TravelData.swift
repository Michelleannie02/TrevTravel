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
import FirebaseStorage
import Foundation

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
        // 10 fields
        var id = ""
        var author = ""
        var changedAt = ""
        var content:Array<String> = []
        var testImg:UIImage?
        var coverImg = ""
        var createdAt = ""
        var likes = ""
        var place = ""
        var shortText = ""
        var title = ""
    }
    
    // Structure for content cell in content table
    struct Content {
        var imgUrl = ""
        var img:UIImage?
    }
    
    var travelArray:[TravelInfo] = []
    var contentArray:[Content] = [] // Content Table View
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
                    aDiary.id = document.documentID
                    aDiary.author = document.data()["author"] as? String ?? ""
                    aDiary.changedAt = document.data()["changedAt"] as? String ?? ""
                    aDiary.content = document.data()["content"] as? Array ?? []
                    aDiary.coverImg = document.data()["coverImg"] as? String ?? ""
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
            newContent.imgUrl = element
            newContent.img = nil //
            self.contentArray.append(newContent)
        }
    }
    
    // ContentView
    func saveContent(img:UIImage){
        var newContent = Content()
        newContent.imgUrl = randomString(length:30) + "_" + String(self.contentArray.count) + ".jpg"
        newContent.img = img
        self.contentArray.append(newContent)
        self.content.append(newContent.imgUrl)
    }
    
    func uploadData() {
        let db = Firestore.firestore()
        let dataDict = [
            "author": newTravelInfo.author,
            "changedAt": "",
            "content": self.content,
            "coverImg": newTravelInfo.coverImg,
            "createdAt": self.getCurrentTime(),
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
            
                // Upload image to Firebase
                if self.contentArray.count != 0 { self.uploadImage(self.contentArray) }
            }
        }
    }
    
    func uploadImage(_ contentArray: Array<Content>){
        var i = 1
        for content in contentArray {
            if let image = content.img {
                UIGraphicsBeginImageContext(CGSize(width: 800, height: 475))
                let ratio = Double(image.size.width/image.size.height)
                let scaleWidth = 800.0
                let scaleHeight = 800.0/ratio
                let offsetX = 0.0
                let offsetY = (scaleHeight-475)/2.0
                image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
                let largeImg = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if let largeImg = largeImg, let jpegData = UIImageJPEGRepresentation(largeImg, 0.7) {
                    let storageRef = Storage.storage().reference()
                    let imgRef = storageRef.child("images").child(content.imgUrl)
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                        guard metadata != nil else {
                            print(error!)
                            return
                        }
                        if i == 1 {print(i, "image uploaded")}
                        else {print(i, "images uploaded")}
                        i += 1
                    }
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {
        var output = ""
        for _ in 0..<length {
            let randomNumber = arc4random()  % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            output.append(randomChar)
        }
        let date = NSDate()
        let timeInterval = Int(date.timeIntervalSince1970*100000)
        output += String(timeInterval)
        return output
    }
    
    func getCurrentTime() -> String {
        let now = NSDate()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dformatter.string(from: now as Date)
    }
    
}
