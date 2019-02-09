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
import GoogleSignIn

class TravelPage: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, TravelDelegate {
    
    @IBOutlet weak var pageScroll: UIScrollView!
    @IBOutlet weak var paragraphTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var changedAtLabel: UILabel!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var shotTextView: UITextView!
    @IBOutlet weak var shortTextViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var commentsTextViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var messageView: UITextField!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var travelID = ""
    let travelData = TravelData()
    var travelPageInfo = TravelData.TravelInfo()
    var userEmail = "Guest"
    let reminder:String = NSLocalizedString("reminder", comment: "")
    let okBtn:String = NSLocalizedString("ok", comment: "")
    let remindLogin:String = NSLocalizedString("remindLogin", comment: "")
    let nocontentmsg:String = NSLocalizedString("nocontentmsg", comment: "")
    let deleteSelectMsg:String = NSLocalizedString("deleteselectmsg", comment: "")
    let deleteSuccessMsg:String = NSLocalizedString("deletesuccessmsg", comment: "")
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        travelData.travelDel = self
        // 0925 Load data when viewDidLoad
        userEmail = Auth.auth().currentUser?.email! ?? "Guest"
        loadPageData()
        loadCommentsData()
        loadIsLikedData() // checkIsLiked insteads
        // In 10 secs reload comments data
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (timer) in
            self.loadCommentsData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        shortTextViewHeightCons.constant = self.shotTextView.contentSize.height
        commentsTextViewHeightCons.constant = self.commentsView.contentSize.height
        
//        paragraphTable.rowHeight = UITableViewAutomaticDimension
//        paragraphTable.estimatedRowHeight = UITableViewAutomaticDimension
        
        let sWidth = pageScroll.frame.size.width
        let sHeight = pageScroll.frame.size.height
        pageScroll.contentSize = CGSize(width: sWidth, height: 300 + sHeight + self.commentsView.contentSize.height + self.shotTextView.contentSize.height)
//        print("Scroll content size w*h: ",sWidth, " ", sHeight)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userEmail = Auth.auth().currentUser?.email! ?? "Guest"
        // 0925 Load data when viewDidLoad
//        loadPageData()
        // 0925 Set textView data when viewWillAppear
//        setTravelData()
        setLikeNumData()
        setIsLikedImgBtn(isLiked: travelData.isLiked)
       
    }
    
    func loadPageData() {
//        travelData.loadPageDB(travelID: travelID, userEmail: userEmail) // Segue sends travelPageInfo insteads
        travelData.newTravelInfo = travelPageInfo
        if travelPageInfo.content.count > 0 {
//            travelData.contentArray.removeAll()
            travelData.loadImages(imgUrlArray: travelPageInfo.content)
        }
        
        if travelPageInfo.likes > 0 && userEmail != "Guest" {
            //            checkIsLiked(userEmail: userEmail) // insteads of setIsLikedImgBtn(isLiked: travelData.isLiked)
            travelData.loadIsLikedDB(travelID: travelID, userEmail: userEmail)
        }
        
        setTravelData()
        
    }
    
    func loadCommentsData() {
        messageView.text = ""
        travelData.commentArray.removeAll()
        travelData.loadCommentsDB(travelID: travelID)
    }
    
    // delete
    func loadIsLikedData() {
        if userEmail != "Guest" { travelData.loadIsLikedDB(travelID: travelID, userEmail: userEmail) }
        else { travelData.isLiked = false }
    }
    
    func loadTable() {
        paragraphTable.reloadData()
    }
    
    func setTravelData() {
//        titleLabel.text = travelData.newTravelInfo.title
//        authorLabel.text = travelData.newTravelInfo.author
//        changedAtLabel.text = travelData.newTravelInfo.changedAt
//        placeBtn.setTitle(travelData.newTravelInfo.place, for: .normal)
//        shotTextView.text = travelData.newTravelInfo.shortText
//        likeNum.text = "(" + String(travelData.newTravelInfo.likes) + ")"
       
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Detail Page"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1078509044, green: 0.5802940753, blue: 0.7578327396, alpha: 1)]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.8549019608, green: 0.5843137255, blue: 0.3490196078, alpha: 1)]
        if userEmail == travelPageInfo.author {
            deleteBtn.isEnabled = true
            deleteBtn.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            editBtn.isEnabled = true
            editBtn.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        } else {
            deleteBtn.isEnabled = false
            deleteBtn.tintColor = UIColor.clear
            editBtn.isEnabled = false
            editBtn.tintColor = UIColor.clear
        }
        
        titleLabel.text = travelPageInfo.title
        authorLabel.text = travelPageInfo.author
        changedAtLabel.text = travelPageInfo.changedAt
        placeBtn.setTitle(travelPageInfo.place, for: .normal)
        shotTextView.text = travelPageInfo.shortText
        likeNum.text = "(" + String(travelPageInfo.likes) + ")"

    }
    
//    func checkIsLiked(userEmail: String) {
//        if travelPageInfo.likeUsers.contains(userEmail) {
////            likeBtn.setImage(UIImage(named: "like_after"), for: UIControlState.normal)
//            travelData.isLiked = true
//        } else {
////            likeBtn.setImage(UIImage(named: "like_before"), for: UIControlState.normal)
//            travelData.isLiked = false
//        }
//    }
  
    func setCommentText() {
        var commentText = ""
        if !travelData.commentArray.isEmpty {
            commentText = "All comments:\n\n\n"
            for comment in travelData.commentArray {
                commentText += comment.createdAt + "\n"
                commentText += comment.user + ":\n"
                commentText += comment.message + "\n\n"
            }
        }
        commentsView.text = commentText
        commentsTextViewHeightCons.constant = self.commentsView.contentSize.height
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
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
        if userEmail == "Guest" {
            self.reminder(self.remindLogin)
//            print("Log in before you do it!")
        } else {
            let aMessage = messageView.text ?? ""
            if aMessage == "" {
                self.reminder(self.nocontentmsg)
            } else {
                travelData.uploadCommentData(travelID: travelID, userEmail: userEmail, message: aMessage)
            }
        }
    }
    
    @IBAction func sendLike() {
        if userEmail != "Guest" { travelData.updateLikesData(travelID:travelID, userEmail:userEmail) }
        else {
            self.reminder(self.remindLogin)
//            print("Log in before you like it!")
        }
        
    }
    
    func reminder(_ msg:String) {
        let alert = UIAlertController(title: reminder, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtn, style: .default, handler: { action in
            switch action.style {
            case .default:
                if msg == self.deleteSelectMsg {
                    self.travelData.deleteData(travelID: self.travelID)
                    self.clearPage()
                }

                print("********** default **********")
            case .cancel:
                print("********** cancel **********")
            case .destructive:
                print("********** destructive **********")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearPage() {
        titleLabel.text = ""
        authorLabel.text = ""
        changedAtLabel.text = ""
        userDefault.set("", forKey: "returnAddress")
        placeBtn.setTitle("", for: .normal)
        shotTextView.text = ""
        commentsView.text = ""
        messageView.text = ""
        likeNum.text = ""
        setIsLikedImgBtn(isLiked: false)

        deleteBtn.isEnabled = false
        deleteBtn.tintColor = UIColor.clear
        editBtn.isEnabled = false
        editBtn.tintColor = UIColor.clear

        travelData.contentArray.removeAll()
        travelData.content.removeAll()
        self.loadTable()
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        
    }
    
    //travelData.newTravelInfo.place
    @IBAction func showMap(_ sender: Any) {
        self.userDefault.set(travelPageInfo.place, forKey: "showMap")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageView.resignFirstResponder()
       
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.view.transform = .identity
        })
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -177)
        })
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteTravel() {
        if travelID != "" {
            reminder(self.deleteSelectMsg)
//            travelData.deleteData(travelID: travelID)
        }
    }
    
    @IBAction func editTravel() {
//        performSegue(withIdentifier: "showEditTravel", sender: Any?)
        performSegue(withIdentifier: "showEditTravel", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditTravel" {
            if let editTravel = segue.destination as? EditTravel {
                editTravel.editTravelInfo = self.travelPageInfo
                if travelPageInfo.content.count > 0 {
                    editTravel.editContentArray = travelData.contentArray
                }
            }
        }
    }
    
}
