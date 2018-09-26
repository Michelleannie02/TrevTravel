//
//  NewTravel.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-18.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

class NewTravel: UIViewController, UITableViewDelegate, UITextViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var newTitle: UITextView!
    @IBOutlet weak var newShortText: UITextView!
    @IBOutlet weak var contentTable: UITableView!
    
    var newTravelData = TravelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newTravelData.dataDel = self // If needs DataDelegate method
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTable()
    }

    func loadTable() {
        contentTable.reloadData()
    }
    
    @IBAction func saveData() {
//        newTravelData.newTravelInfo.author = "Shan" //
        newTravelData.newTravelInfo.place = "Vasagatan 22, Stockholm, Sweden" // Adjust
        newTravelData.newTravelInfo.shortText = newShortText.text ?? ""
        newTravelData.newTravelInfo.title = newTitle.text ?? ""
        
        // upload the saved data to Firebase
        newTravelData.uploadData()
        
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTravelData.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
        let row = indexPath.row
        let contentCell = newTravelData.contentArray[row]
        cell.newImage?.image = contentCell.img
        return cell
    }

    @IBAction func newPicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender.tag == 1 { imagePicker.sourceType = .camera }
        else if sender.tag == 2 { imagePicker.sourceType = .photoLibrary }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Save the picked pickture to contentArray
        newTravelData.saveContent(img: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
