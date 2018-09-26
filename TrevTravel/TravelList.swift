//
//  TravelList.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
//import Firebase

class TravelList: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDelegate{
    
    @IBOutlet weak var travelTable: UITableView!
    
    var travelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        travelTable.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Get all the travel diaries data from Firebase
        travelData.dataDel = self    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadTable() {
        travelTable.reloadData()
        //        loadActivity.isHidden = true
    }
    
    // Get all the travel diaries data from Firebase
    func loadData() {
        travelData.travelArray.removeAll() // Clear the table view before getting all data
        travelData.loadDB() // Get data from Firebase
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        let travelCell = travelData.travelArray[row]
        
        cell.titleLabel?.text = travelCell.title
        cell.authorLabel?.text = travelCell.author
        cell.createdAtLabel?.text = travelCell.createdAt
//        cell.travelImage?.image = UIImage(named: travelCell.coverImgUrl) // When coverImgUrl is local image. Can try coverImg is nil (not gotten from fb storage) then get as UIImage(named: travelCell.coverImgUrl)
        cell.travelImage?.image = travelCell.coverImg
        cell.shortTextLabel?.text = travelCell.shortText
        cell.likesLabel?.text = String(travelCell.likes)
        cell.placeLabel?.text = travelCell.place
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        performSegue(withIdentifier: "showTravelPage", sender: row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTravelPage" {
            if let travelPage = segue.destination as? TravelPage {
                if let indx = sender as? Int {
                    let aTravel = travelData.travelArray[indx]
                    travelPage.travelID = aTravel.id
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
