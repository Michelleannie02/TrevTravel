//
//  TravelPage.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class TravelPage: UIViewController {
    
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

    }
    
    func setTravelData() {
//        titleLabel.text = 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
