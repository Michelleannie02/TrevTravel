//
//  NewTravel.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-18.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

class NewTravel: UIViewController, UITableViewDelegate, UITextViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newTitle: UITextField!
//    @IBOutlet weak var newShortText: UITextField!
    @IBOutlet weak var newContent: UITextView!
    
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var addressBtn: UIButton!

    
    var newTravelData = TravelData()
    var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        newTravelData.dataDel = self // If needs DataDelegate method
        
        self.newTitle.delegate = self
        self.newContent.delegate = self
        
        // decorate the UITextView(newContent)
        self.newContent.layer.borderWidth = 1.0
        self.newContent.layer.borderColor = UIColor.gray.cgColor
        
        // newContent PlaceHolder
        placeholderLabel = UILabel()
        placeholderLabel.text = "Some describtion of your photos"
        newContent.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (newContent.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !newContent.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !newContent.text.isEmpty
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
        newTravelData.newTravelInfo.shortText = newContent.text ?? ""
//        newTravelData.newTravelInfo.shortText = newShortText.text ?? ""
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
    
    
    // Hide keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when user tap on return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newTitle.resignFirstResponder()
        return(true)
    }
    
    private func textFieldShouldReturn(_ textView: UITableView) -> Bool {
        newContent.resignFirstResponder()
        return(true)
    }
    
    
}
