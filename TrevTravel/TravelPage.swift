//
//  TravelPage.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class TravelPage: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, TravelDelegate {
    
    @IBOutlet weak var pageScroll: UIScrollView!
    @IBOutlet weak var paragraphTable: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var changedAtLabel: UILabel!
    @IBOutlet weak var shotTextView: UITextView!
    @IBOutlet weak var commentsView: UITextView!
    @IBOutlet weak var messageView: UITextField!
    
    var travelID = ""
    let travelData = TravelData()

    override func viewDidLoad() {
        super.viewDidLoad()
        travelData.travelDel = self
        // 0925 Load data when viewDidLoad
        loadPageData()
        loadCommentsData()
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
    }
    
    func loadPageData() {
        travelData.loadPageDB(travelID: travelID)
        
    }
    
    func loadCommentsData() {
        travelData.commentArray.removeAll()
        travelData.loadCommentsDB(travelID: travelID)
    }
    
    func loadTable() {
        paragraphTable.reloadData()
    }
    
    func setTravelData() {
        titleLabel.text = travelData.newTravelInfo.title
        authorLabel.text = travelData.newTravelInfo.author
        changedAtLabel.text = travelData.newTravelInfo.changedAt
        shotTextView.text = travelData.newTravelInfo.shortText
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
    
    // comment enter action func
    @IBAction func sendComment() {
        
//        travelData.uploadCommentData(travelID: <#T##String#>)
    }
    
    @IBAction func sendLike() {
        travelData.updateLikesData(travelID: travelID)
    }
    
    
    @IBAction func chooseEdit() {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
