//
//  TravelList.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-20.
//  Copyright © 2018 Song Liu. All rights reserved.
//

import UIKit

class TravelList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var travelTable: UITableView!
    let travelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the amount of the section
        return travelData.travelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for:indexPath) as! TravelCell
        let row = indexPath.row
        let travelCell = travelData.travelArray[row]
        cell.titleLabel?.text = travelCell.title
        cell.travelImage?.image = UIImage(named: travelCell.coverImg)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
