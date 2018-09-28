//
//  TravelList.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

extension TravelList: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


class TravelList: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDelegate{
    
    @IBOutlet weak var travelTable: UITableView!
    
    var travelData = TravelData()
    let searchController = UISearchController(searchResultsController: nil) // use the same view when searching
//    var filteredTravels = [TravelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController // Valid only ios11 or newer
        } else {
            // Fallback on earlier versions
            travelTable.tableHeaderView = searchController.searchBar // added in ch version, can older ios10
        }
        definesPresentationContext = true

//        travelTable.separatorStyle = UITableViewCellSeparatorStyle.none // Display cell line
        
        // Get all the travel diaries data from Firebase
        travelData.dataDel = self
        
        //0928
//        loadData()
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
        if isFiltering() {
            return travelData.searchArray.count
        }
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        var travelCell = travelData.travelArray[row]
        
//        let travelCell: TravelData.TravelInfo // Not right
        if isFiltering(){
            travelCell = travelData.searchArray[row]
        }
        
        cell.titleLabel?.text = travelCell.title
        cell.authorLabel?.text = travelCell.author
        cell.createdAtLabel?.text = travelCell.createdAt
//        cell.travelImage?.image = UIImage(named: travelCell.coverImgUrl) // When coverImgUrl is local image. Can try coverImg is nil (not gotten from fb storage) then get as UIImage(named: travelCell.coverImgUrl)
        cell.travelImage?.image = travelCell.coverImg
        cell.shortTextLabel?.text = travelCell.shortText
        cell.likesLabel?.text = "(" + String(travelCell.likes) + ")"
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
//                    let aTravel = travelData.travelArray[indx]
                    
                    let aTravel:TravelData.TravelInfo
                    if isFiltering() {
                        aTravel = travelData.searchArray[indx]
                    } else {
                        aTravel = travelData.travelArray[indx]
                    }
                    
                    travelPage.travelID = aTravel.id
                }
            }
        }
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        travelData.searchArray = travelData.travelArray.filter({( aTravel : TravelData.TravelInfo) -> Bool in
            // filter author+title+shortText
            let filterString = aTravel.author + " " + aTravel.title + " " + aTravel.shortText
            return filterString.lowercased().contains(searchText.lowercased())
        })
        
        travelTable.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
