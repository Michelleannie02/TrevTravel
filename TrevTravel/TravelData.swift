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

// Home
protocol DataDelegate {
    func loadTable()
}

// TravelPage view
protocol TravelDelegate {
    func setTravelData()
    func loadTable()
    func setCommentText()
    func loadCommentsData()
}

class TravelData {
    
    var dataDel: DataDelegate?
    var travelDel: TravelDelegate?
    
    struct TravelInfo {
        // 11 fields. 9 fields saved to firebase
        var id = ""
        var author = ""
        var changedAt = ""
        var content:Array<String> = [] // Home, Add
        var coverImgUrl = ""
        var coverImg:UIImage?
        var createdAt = ""
        var likes = 0
        var place = ""
        var shortText = ""
        var title = ""
    }
    
    // Structure for content cell in content table
    struct Content {
        var imgUrl = "" //
        var img:UIImage?
    }
    
    struct Comment {
        var id = ""
        var createdAt = ""
        var message = ""
        var user = ""
    }
    
    var travelArray:[TravelInfo] = []
    var contentArray:[Content] = [] // Content Table View, TravelPage
    var content:Array<String> = [] // Save content's info when add a picture
    var commentArray:[Comment] = [] // Travel Page
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
//                    aDiary.content = document.data()["content"] as? Array ?? [] // Load the specific diary by id again
                    aDiary.coverImgUrl = document.data()["coverImgUrl"] as? String ?? ""
                    aDiary.createdAt = document.data()["createdAt"] as? String ?? ""
                    aDiary.likes = (document.data()["likes"] as? Int)!
                    aDiary.place = document.data()["place"] as? String ?? ""
                    aDiary.shortText = document.data()["shortText"] as? String ?? ""
                    aDiary.title = document.data()["title"] as? String ?? ""
                    
                    self.travelArray.append(aDiary)
//                    self.setContentArray(array: aDiary.content) // Load the specific diary by id again
                }
                self.dataDel?.loadTable()
                // TravelList loads firebasedata first, then loads firebasestorage
                if aDiary.coverImgUrl != "" { self.loadCoverImg() }
            }
        }
    }
    
    func loadCoverImg() {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        for (index, var aDiary) in travelArray.enumerated() {
            let imgRef = imagesRef.child(aDiary.coverImgUrl)
            imgRef.getData(maxSize: 1024*1024) { (data, error) in
                if let error = error { print(error) }
                else {
                    if let imgData = data {
                        aDiary.coverImg = UIImage(data: imgData)
//                        self.travelArray[index] = aDiary
                        self.travelArray[index].coverImg = aDiary.coverImg
                    }
                }
                self.dataDel?.loadTable()
            }
        }
    }
   
    // Add - ContentView
    func saveContent(img:UIImage){
        var newContent = Content()
        // Set the name of the imgUrl: randomString+currentTimeInterval+index in the array.jpg
        newContent.imgUrl = randomString(length:30) + "_" + String(self.contentArray.count) + ".jpg"
        newContent.img = img
        self.contentArray.append(newContent)
        self.content.append(newContent.imgUrl)
    }
    
    func uploadData() {
        if newTravelInfo.coverImgUrl == "" { newTravelInfo.coverImgUrl = self.content[0] }
        
        let db = Firestore.firestore()
        let dataDict = [
            "author": newTravelInfo.author,
            "changedAt": self.getCurrentTime(),
            "content": self.content,
            "coverImgUrl": newTravelInfo.coverImgUrl,
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
                print("Travel diary document saved")
            
                // Upload image to Firebase
                if self.contentArray.count != 0 { self.uploadImage(self.contentArray) }
            }
        }
    }
    
    func uploadImage(_ contentArray: Array<Content>){
        for (index, content) in contentArray.enumerated() {
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
                        if index == 0 {print(index+1, "image uploaded")}
                        else {print(index+1, "images uploaded")}
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
    
    func loadPageDB(travelID:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("travelDiary").document(travelID)
        docRef.getDocument { (document, error) in
            if let error = error { print(error) }
            else if let document = document, document.exists {
                if let dataDescription = document.data() {
                    self.newTravelInfo.author = dataDescription["author"] as? String ?? ""
                    self.newTravelInfo.changedAt = dataDescription["changedAt"] as? String ?? ""
                    self.newTravelInfo.content = dataDescription["content"] as? Array ?? []
                    self.newTravelInfo.coverImgUrl = dataDescription["coverImgUrl"] as? String ?? ""
                    self.newTravelInfo.createdAt = dataDescription["createdAt"] as? String ?? ""
                    self.newTravelInfo.likes = (dataDescription["likes"] as? Int)!
                    self.newTravelInfo.place = dataDescription["place"] as? String ?? ""
                    self.newTravelInfo.shortText = dataDescription["shortText"] as? String ?? ""
                    self.newTravelInfo.title = dataDescription["title"] as? String ?? ""
                    
                    self.travelDel?.setTravelData()
                    
                    if self.newTravelInfo.content.count > 0 {
                        self.loadImages(imgUrlArray: self.newTravelInfo.content)
                    }
                }
            } else { print("Document does not exist in database")}
        }
    }
    
    
    func loadImages(imgUrlArray: Array<String>) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        var aContent = Content()
        for imgUrl in imgUrlArray {
            let imgRef = imagesRef.child(imgUrl)
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error { print(error) }
                else {
                    if let imgData = data {
                        if let parImg = UIImage(data: imgData) {
                            aContent.imgUrl = imgUrl
                            aContent.img = parImg
                            self.contentArray.append(aContent)
                            // self.travelDel?.loadTable() // Same Better?
                        }
                    }
                }
                self.travelDel?.loadTable()
            }
        }
//        self.travelDel?.loadTable() // newTravelInfo.contentStruct
    }
    
    func loadCommentsDB(travelID:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("diaryComments").document(travelID).collection("comments")
        docRef.getDocuments { (querySnapshot, err) in
            if let error = err { print("Error getting comments document: ", error) }
            else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    var aComment = Comment()
                    aComment.id = document.documentID
                    aComment.createdAt = document.data()["createdAt"] as? String ?? ""
                    aComment.message = document.data()["message"] as? String ?? ""
                    aComment.user = document.data()["user"] as? String ?? ""

                    self.commentArray.append(aComment)
                }
                self.travelDel?.setCommentText()
            }
        }
    }

    func uploadCommentData(travelID:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("diaryComments").document(travelID).collection("comments")
        
        let dataDict = [
            "createdAt": self.getCurrentTime(),
            "message": "",
            "user": ""
            ] as [String : Any]
        
        docRef.document().setData(dataDict) { (err) in
            if let error = err {
                print("Error uploading data to diaryComments: \(error)")
            } else {
                print("Comments document saved")
                // Reload commentTextView.
                self.travelDel?.loadCommentsData()
            }
        }
    }
    
    func updateLikesData(travelID:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("travelDiary").document(travelID)

        docRef.getDocument{ (document, error) in
            if let error = error { print(error) }
            else if let document = document, document.exists {
                if let dataDescription = document.data() {
//                    self.newTravelInfo.likes = (dataDescription["likes"] as? Int)! + 1
//                    docRef.setValue(self.newTravelInfo.likes, forKey: "likes")
//                    self.travelDel?.setTravelData() // 改likes显示数据
                    
                    self.newTravelInfo.author = dataDescription["author"] as? String ?? ""
                    self.newTravelInfo.changedAt = dataDescription["changedAt"] as? String ?? ""
                    self.newTravelInfo.content = dataDescription["content"] as? Array ?? []
                    self.newTravelInfo.coverImgUrl = dataDescription["coverImgUrl"] as? String ?? ""
                    self.newTravelInfo.createdAt = dataDescription["createdAt"] as? String ?? ""
                    self.newTravelInfo.likes = (dataDescription["likes"] as? Int)! + 1
                    self.newTravelInfo.place = dataDescription["place"] as? String ?? ""
                    self.newTravelInfo.shortText = dataDescription["shortText"] as? String ?? ""
                    self.newTravelInfo.title = dataDescription["title"] as? String ?? ""
                    
                    let dataDict = [
                        "author": self.newTravelInfo.author,
                        "changedAt": self.newTravelInfo.changedAt,
                        "content": self.newTravelInfo.content,
                        "coverImgUrl": self.newTravelInfo.coverImgUrl,
                        "createdAt": self.newTravelInfo.createdAt,
                        "likes": self.newTravelInfo.likes,
                        "place": self.newTravelInfo.place,
                        "shortText": self.newTravelInfo.shortText,
                        "title": self.newTravelInfo.title
                        ] as [String : Any]
                    
                    docRef.setData(dataDict)
                }
            } else { print("Document does not exist in database")}
        }
    }
    
}
