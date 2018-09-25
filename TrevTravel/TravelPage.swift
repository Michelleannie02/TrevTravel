//
//  TravelPage.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class TravelPage: UIViewController, UITableViewDelegate, UITableViewDataSource, TravelDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var changedAtLabel: UILabel!
    @IBOutlet weak var shotTextView: UITextView!    
    @IBOutlet weak var paragraphTable: UITableView!
    @IBOutlet weak var commentsView: UITextView!
    
    
    var travelID = ""
    let travelData = TravelData()

    override func viewDidLoad() {
        super.viewDidLoad()
        travelData.travelDel = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPageData()
    }
    
    func loadPageData() {
//        travelData.contentArray.removeAll()
        travelData.loadPageDB(travelID: travelID)
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
  
    func loadCommentText() {
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
