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
import FirebaseAuth
import Foundation

// Home
protocol DataDelegate {
    func loadTable()
}

// TravelPage view
protocol TravelDelegate {
    func setTravelData()
    func setLikeNumData()
    func setIsLikedImgBtn(isLiked:Bool)
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
//        var likeUsers:Array<String> = [] // Insteads of loadLikesData/uploadLikesData
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
    
    var travelKeyArray:[String] = []
    var travelArray:[TravelInfo] = []
    var searchArray:[TravelInfo] = []
    var contentArray:[Content] = [] // Content Table View, TravelPage
    var content:Array<String> = [] // Save content's info when add a picture
    var commentArray:[Comment] = [] // Travel Page
    var newTravelInfo = TravelInfo()
    
    var isLiked:Bool = false
   
    // Load data from Firebase. HOME // delete HOME snapshotListener, func dataListener() insteads
    func loadDB(){
        let db = Firestore.firestore()
//        let travelDb = db.collection("travelDiary").order(by: "createAt", descending: true)
        db.collection("travelDiary").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents of travelDiary: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                var aDiary = TravelInfo()
                for (index, document) in qSnapshot.documents.enumerated() {
                    if !self.travelKeyArray.contains(document.documentID) {
                        self.travelKeyArray.append(document.documentID)
                        
                        aDiary.id = document.documentID
                        aDiary.author = document.data()["author"] as? String ?? ""
                        aDiary.changedAt = document.data()["changedAt"] as? String ?? ""
                        aDiary.content = document.data()["content"] as? Array ?? [] // Saved for travelPage and editTravel
                        aDiary.coverImgUrl = document.data()["coverImgUrl"] as? String ?? ""
                        aDiary.createdAt = document.data()["createdAt"] as? String ?? ""
                        aDiary.likes = (document.data()["likes"] as? Int)!
                        aDiary.place = document.data()["place"] as? String ?? ""
                        aDiary.shortText = document.data()["shortText"] as? String ?? ""
                        aDiary.title = document.data()["title"] as? String ?? ""
                        
                        self.travelArray.append(aDiary)
                        if aDiary.coverImgUrl != "" { self.loadCoverImg(index:index) } //0928  index:index
                    }
                }
                self.dataDel?.loadTable()
                // TravelList loads firebasedata first, then loads firebasestorage
//                if aDiary.coverImgUrl != "" { self.loadCoverImg() } //0928
            }
        }
        
    }
    
    //0928  index:index
    func loadCoverImg(index:Int) {
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
   
    // delete. Segue sends travelPageInfo insteads
    func loadPageDB(travelID:String, userEmail:String) {
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
                    
                    if self.newTravelInfo.likes > 0 && userEmail != "Guest" {
                        self.loadIsLikedDB(travelID: travelID, userEmail: userEmail)
                    }
                    
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
        self.contentArray.removeAll()
        for (imgUrl) in imgUrlArray {
            let imgRef = imagesRef.child(imgUrl)
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error { print(error) }
                else {
                    if let imgData = data {
                        if let parImg = UIImage(data: imgData) {
                            aContent.imgUrl = imgUrl
                            aContent.img = parImg
//                            if self.contentArray.count < imgUrlArray.count {
//                                self.contentArray.append(aContent)
//                            }
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
                
                if !self.commentArray.isEmpty {
                    // Sort the comments according createdAt
                    let increases = self.commentArray.sorted(by: { (a, b) -> Bool in
                        return a.createdAt > b.createdAt
                    })
                    
                    self.commentArray = increases.filter({ (a) -> Bool in
                        return true
                    })
                }
                self.travelDel?.setCommentText()
            }
        }
        
    }
    
    // if loged in, load isLiked data from FB
    func loadIsLikedDB(travelID:String, userEmail:String){
        let db = Firestore.firestore()
        let docRef = db.collection("likeDiary").document(travelID).collection("isLiked").document(userEmail)
        docRef.getDocument { (document, error) in
            if let error = error { print(error) }
            else if let document = document, document.exists {
                if let dataDescription = document.data() {
                    self.isLiked = dataDescription["isLiked"] as? Bool ?? false
                    
                    self.travelDel?.setIsLikedImgBtn(isLiked: self.isLiked)
                }
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
    
    // Add/Edit a travel diary
    func uploadData(isEdit:Bool) {
        if self.contentArray.count != 0 {
            newTravelInfo.coverImgUrl = self.content[0]
            // Upload image to Firebase
            self.uploadImage(self.contentArray)
        } else {
            newTravelInfo.coverImgUrl = ("NoImage.jpg"as String?)! // Default img for NO IMAGE
        }
        
        let db = Firestore.firestore()
        
        if !isEdit {
            newTravelInfo.createdAt = self.getCurrentTime()
            newTravelInfo.id = newTravelInfo.createdAt.replacingOccurrences(of: " ", with: "_") + newTravelInfo.author
            newTravelInfo.likes = 0
        }

        let dataDict = [
            "author": newTravelInfo.author, // 自动取login的email
            "changedAt": self.getCurrentTime(),
            "content": self.content,
            "coverImgUrl": newTravelInfo.coverImgUrl,
            "createdAt": newTravelInfo.createdAt,
            "likes": newTravelInfo.likes,
            "place": newTravelInfo.place, // 如果user定位或输入了本diary的地址
            "shortText": newTravelInfo.shortText,
            "title": newTravelInfo.title
            ] as [String : Any]
        
        db.collection("travelDiary").document(newTravelInfo.id).setData(dataDict) { err in
            if let error = err {
                print("Error uploading to travelDiary: \(error)")
            } else {
                print("Travel diary document saved")

                // Upload image to Firebase. Move to listener
//                if self.contentArray.count != 0 { self.uploadImage(self.contentArray) }
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
    
    func uploadCommentData(travelID:String, userEmail:String, message:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("diaryComments").document(travelID).collection("comments")
        
        let dataDict = [
            "createdAt": self.getCurrentTime(),
            "message": message,
            "user": userEmail
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
   
    func updateLikesData(travelID:String, userEmail:String) {
        var afterLiking:Bool
        var didLike:Int
        if self.isLiked {
            afterLiking = false
            didLike = -1
        } else {
            afterLiking = true
            didLike = 1
        }
        
        let dataDict = ["isLiked": afterLiking] as [String : Any]
        let db = Firestore.firestore()
        let likeRef = db.collection("likeDiary").document(travelID).collection("isLiked").document(userEmail)

        likeRef.setData(dataDict){ (err) in
            if let error = err {
                print("Error updating data to likeDiary: \(error)")
            } else {
                self.isLiked = afterLiking
                self.travelDel?.setIsLikedImgBtn(isLiked: self.isLiked)

                // update travelDiary likes number
                self.updateLikeNumData(travelID:travelID, didLike:didLike)
            }
        }
      
    }
    
    func updateLikeNumData(travelID:String, didLike:Int){
        let db = Firestore.firestore()
        let docRef = db.collection("travelDiary").document(travelID)
        docRef.getDocument{ (document, error) in
            if let error = error { print(error) }
            else if let document = document, document.exists {
                if let dataDescription = document.data() {
                    self.newTravelInfo.author = dataDescription["author"] as? String ?? ""
                    self.newTravelInfo.changedAt = dataDescription["changedAt"] as? String ?? ""
                    self.newTravelInfo.content = dataDescription["content"] as? Array ?? []
                    self.newTravelInfo.coverImgUrl = dataDescription["coverImgUrl"] as? String ?? ""
                    self.newTravelInfo.createdAt = dataDescription["createdAt"] as? String ?? ""
                    self.newTravelInfo.likes = (dataDescription["likes"] as? Int)! + didLike
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
                    self.travelDel?.setLikeNumData()
                }
            } else { print("Document does not exist in database")}
        }
    }
    
    func deleteData(travelID:String) {
        let db = Firestore.firestore()
        db.collection("travelDiary").document(travelID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                // delete isLiked data
                let likeRef = db.collection("likeDiary").document(travelID).collection("isLiked")
                likeRef.getDocuments { (querySnapshot, error) in
                    if let error = error { print(error) }
                    else {
                        guard let qSnapshot = querySnapshot else {return}
                        for document in qSnapshot.documents {
                            likeRef.document(document.documentID).delete()
                        }
                    }
                }
                db.collection("likeDiary").document(travelID).delete()
                
                // delete comments
                let cmmntRef = db.collection("diaryComments").document(travelID).collection("comments")
                cmmntRef.getDocuments { (querySnapshot, error) in
                    if let error = error { print(error) }
                    else {
                        guard let qSnapshot = querySnapshot else {return}
                        for document in qSnapshot.documents {
                            cmmntRef.document(document.documentID).delete()
                        }
                    }
                }
                db.collection("diaryComments").document(travelID).delete()
                
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteImages(imgUrlArray: [String]) {
        let imageRef = Storage.storage().reference().child("images")
        for imgUrl in imgUrlArray {
            imageRef.child(imgUrl).delete { (error) in
                if let err = error {print("Delete img in storage failed: ", err)}
                else {print("Delete img in storage succeeded: ", imgUrl)}
            }
        }
    }
    
    func dataListener() -> ListenerRegistration {
        let db = Firestore.firestore()
        let listener = db.collection("travelDiary").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            var aDiary = TravelInfo()
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
//                    print("New data: \(diff.document.data())")
                    print("added index: ",Int(diff.newIndex))
                    if !self.travelKeyArray.contains(diff.document.documentID) {
                        self.travelKeyArray.append(diff.document.documentID)
                        
                        aDiary.id = diff.document.documentID
                        aDiary.author = diff.document.data()["author"] as? String ?? ""
                        aDiary.changedAt = diff.document.data()["changedAt"] as? String ?? ""
                        aDiary.content = diff.document.data()["content"] as? Array ?? []
                        aDiary.coverImgUrl = diff.document.data()["coverImgUrl"] as? String ?? ""
                        aDiary.createdAt = diff.document.data()["createdAt"] as? String ?? ""
                        aDiary.likes = (diff.document.data()["likes"] as? Int)!
                        aDiary.place = diff.document.data()["place"] as? String ?? ""
                        aDiary.shortText = diff.document.data()["shortText"] as? String ?? ""
                        aDiary.title = diff.document.data()["title"] as? String ?? ""

                        self.travelKeyArray.insert(aDiary.id, at: Int(diff.newIndex))
                        self.travelArray.insert(aDiary, at: Int(diff.newIndex))
                        self.loadCoverImg(index:Int(diff.newIndex))
//                        if aDiary.coverImgUrl != "" { self.loadCoverImg(index:Int(diff.newIndex)) }
//                        print("Listener add.")
//                        self.dataDel?.loadTable()
                    }
                }
                if (diff.type == .modified) {
//                        print("Modified data: \(diff.document.data())")
                    if let index = self.travelKeyArray.firstIndex(of: diff.document.documentID), index <= self.travelKeyArray.count {
                        aDiary.id = diff.document.documentID
                        aDiary.author = diff.document.data()["author"] as? String ?? ""
                        aDiary.changedAt = diff.document.data()["changedAt"] as? String ?? ""
                        aDiary.content = diff.document.data()["content"] as? Array ?? []
                        aDiary.coverImgUrl = diff.document.data()["coverImgUrl"] as? String ?? ""
                        aDiary.createdAt = diff.document.data()["createdAt"] as? String ?? ""
                        aDiary.likes = (diff.document.data()["likes"] as? Int)!
                        aDiary.place = diff.document.data()["place"] as? String ?? ""
                        aDiary.shortText = diff.document.data()["shortText"] as? String ?? ""
                        aDiary.title = diff.document.data()["title"] as? String ?? ""
                        
                        self.travelArray[index] = aDiary
                        if aDiary.coverImgUrl != "" { self.loadCoverImg(index:Int(diff.newIndex)) }
//                        print("Listener edit. travelArray[index]: NO. ", index)
                        self.dataDel?.loadTable()
                    }
                }
                if (diff.type == .removed) {
//                        print("Removed data: \(diff.document.data())")
                    if let index = self.travelKeyArray.firstIndex(of: diff.document.documentID), index <= self.travelArray.count {
                        print("index of delete: ", index)
                        // delete images
                        if self.travelArray[index].content.count > 0 {
                            self.deleteImages(imgUrlArray: self.travelArray[index].content)
                        }
                        
                        self.travelKeyArray.remove(at: index)
                        self.travelArray.remove(at: index)
                        
                        self.dataDel?.loadTable()
                    }
                }
            }
        }
        return listener
    }
    

}
