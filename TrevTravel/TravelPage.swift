//
//  TravelPage.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TravelPage: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, TravelDelegate {
    
    @IBOutlet weak var pageScroll: UIScrollView!
    @IBOutlet weak var paragraphTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var changedAtLabel: UILabel!
    @IBOutlet weak var shotTextView: UITextView!
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var messageView: UITextField!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var travelID = ""
    let travelData = TravelData()
    var userEmail = Auth.auth().currentUser?.email! ?? "Guest"

    override func viewDidLoad() {
        super.viewDidLoad()
        travelData.travelDel = self
        // 0925 Load data when viewDidLoad
        loadPageData()
        loadCommentsData()
        loadIsLikedData()
        // In 10 secs reload comments data
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            self.loadCommentsData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        let sWidth = pageScroll.frame.size.width
        let sHeight = pageScroll.frame.size.height
        pageScroll.contentSize = CGSize(width: sWidth, height: 2*sHeight)
        print("Scroll content size w*h: ",sWidth, " ", sHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 0925 Load data when viewDidLoad
//        loadPageData()
        // 0925 Set textView data when viewWillAppear
        setTravelData()
        setLikeNumData()
        setIsLikedImgBtn(isLiked: travelData.isLiked)
    }
    
    func loadPageData() {
        travelData.loadPageDB(travelID: travelID)
        
    }
    
    func loadCommentsData() {
        travelData.commentArray.removeAll()
        travelData.loadCommentsDB(travelID: travelID)
    }
    
    func loadIsLikedData() {
        if userEmail != "Guest" { travelData.loadIsLikedDB(travelID: travelID, userEmail: userEmail) }
        else { travelData.isLiked = false }
    }
    
    func loadTable() {
        paragraphTable.reloadData()
    }
    
    func setTravelData() {
        titleLabel.text = travelData.newTravelInfo.title
        authorLabel.text = travelData.newTravelInfo.author
        changedAtLabel.text = travelData.newTravelInfo.changedAt
        shotTextView.text = travelData.newTravelInfo.shortText
        
        likeNum.text = "(" + String(travelData.newTravelInfo.likes) + ")"
    }
  
    func setCommentText() {
        var commentText = ""
        for comment in travelData.commentArray {
            commentText += comment.createdAt + "\n"
            commentText += comment.user + ":\n"
            commentText += comment.message + "\n\n"
        }
        commentsView.text = commentText
    }
    
    func setLikeNumData() {
        likeNum.text = "(" + String(travelData.newTravelInfo.likes) + ")"
        
    }
    
    func setIsLikedImgBtn(isLiked:Bool) {
        if isLiked {
            likeBtn.setImage(UIImage(named: "like_after"), for: UIControlState.normal)
        } else {
            likeBtn.setImage(UIImage(named: "like_before"), for: UIControlState.normal)
        }
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return travelData.contentArray.count
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParagraphCell", for: indexPath) as! ParagraphCell
        let row = indexPath.row
        let paragraphCell = travelData.contentArray[row]
        cell.parImgView.image = paragraphCell.img
        return cell
    }
    
    @IBAction func sendComment() {
//        if userEmail != "Guest" {
//            travelData.newComment.message = commentsView.text ?? ""
//            travelData.uploadCommentData(travelID: travelID, userEmail: userEmail)
//        }
        let aMessage = messageView.text ?? ""
        travelData.uploadCommentData(travelID: travelID, userEmail: userEmail, message: aMessage)
    }
    
    @IBAction func sendLike() {
        if userEmail != "Guest" { travelData.updateLikesData(travelID:travelID, userEmail:userEmail) }
        else {
            // 提示要log in
            print("Log in before like it!")
        }
        
    }
    
    @IBAction func chooseEdit() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
