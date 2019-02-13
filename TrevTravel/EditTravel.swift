//
//  EditTravel.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2019-02-07.
//  Copyright © 2019 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class EditTravel: UIViewController, UITableViewDelegate, UITextViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newTitle: UITextField!
    //    @IBOutlet weak var newShortText: UITextField!
    @IBOutlet weak var newContent: UITextView!
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    
    // Translation
    let reminder:String = NSLocalizedString("reminder", comment: "")
    let okBtn:String = NSLocalizedString("ok", comment: "")
    let noContentMsg:String = NSLocalizedString("nocontentmsg", comment: "")
    let noLoginMsg:String = NSLocalizedString("nologinmsg", comment: "")
    let saveSuccessMsg:String = NSLocalizedString("savesuccessmsg", comment: "")
    let guest:String = NSLocalizedString("guest", comment: "")
    let contentTextPlaceHolder:String = NSLocalizedString("contenttextplaceholder", comment: "")
    
    var travelID = ""
    var newTravelData = TravelData()
    var editTravelInfo = TravelData.TravelInfo()
    var editContentArray: [TravelData.Content] = []
    var placeholderLabel: UILabel!
    var userEmail = "Guest"
    var address:String = ""
    let userDefault = UserDefaults.standard
    var imgsToDelete:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEditInfo()
        
        self.newTitle.delegate = self
        self.newContent.delegate = self
        
        // decorate the UITextView(newContent)
        self.newContent.layer.borderWidth = 1.0
        self.newContent.layer.borderColor = UIColor.gray.cgColor
        
        // newContent PlaceHolder
        placeholderLabel = UILabel()
        placeholderLabel.text = contentTextPlaceHolder
        newContent.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (newContent.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !newContent.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !newContent.text.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userEmail = Auth.auth().currentUser?.email! ?? guest

        setTravelData()
        loadTable()
    }

    func loadEditInfo() {
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Edit"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1240907066, green: 0.6070433936, blue: 1, alpha: 1)]
        deleteBtn.isEnabled = false
        deleteBtn.tintColor = UIColor.clear
        
        userEmail = Auth.auth().currentUser?.email! ?? "Guest"
        newTravelData.newTravelInfo = editTravelInfo
        if editContentArray.count > 0 {
            newTravelData.contentArray = editContentArray
            newTravelData.content = editTravelInfo.content
        }
        
        newTitle.text = newTravelData.newTravelInfo.title
        newContent.text = newTravelData.newTravelInfo.shortText
        
        setTravelData()
    }
    
    func setTravelData() {
        if userDefault.string(forKey: "returnAddress") != "" {
            address = userDefault.string(forKey: "returnAddress")!
            newTravelData.newTravelInfo.place = address
        } else {
            address = newTravelData.newTravelInfo.place
        }
        addressBtn.setTitle(address, for: .normal)
        
        if editTravelInfo.content.count > 0 {
            loadTable()
        }
    }
    
    func loadTable() {
        contentTable.reloadData()
    }
    
    @IBAction func saveData() {
        if userEmail == guest {
            reminder(noLoginMsg)
        } else if newTitle.text == "" {
            reminder(noContentMsg)
        } else {
            newTravelData.newTravelInfo.author = userEmail
            newTravelData.newTravelInfo.place = address
            newTravelData.newTravelInfo.shortText = newContent.text ?? ""
            newTravelData.newTravelInfo.title = newTitle.text ?? ""
            print("newTravelData.newTravelInfo.place: ", newTravelData.newTravelInfo.place)
            
            // upload the saved data to Firebase , oldContentCount: editTravelInfo.content.count
            newTravelData.uploadData(isEdit:true)
            if imgsToDelete.count > 0 {
                newTravelData.deleteImages(imgUrlArray: imgsToDelete)
            }
            
            reminder(saveSuccessMsg)
            
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        newTravelData.rowToChange = String(row)
        let imgUrlToDelete = newTravelData.content[row]
        if editTravelInfo.content.contains(imgUrlToDelete), !imgsToDelete.contains(imgUrlToDelete) {
            imgsToDelete.append(imgUrlToDelete)
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if editingStyle == .delete {            
            let imgUrlToDelete = newTravelData.content[row]
//            newTravelData.deleteImages(imgUrlArray: [imgUrlToDelete])
            if editTravelInfo.content.contains(imgUrlToDelete), !imgsToDelete.contains(imgUrlToDelete) {
                imgsToDelete.append(imgUrlToDelete)
            }
            newTravelData.content.remove(at: row)
            newTravelData.contentArray.remove(at: row)
            self.loadTable()
        }
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
    
    func reminder(_ msg:String) {
        let alert = UIAlertController(title: reminder, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtn, style: .default, handler: { action in
            switch action.style {
            case .default:
                if msg == self.saveSuccessMsg {
                    self.clearContent()
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
    
    func clearContent() {
        newTitle.text = ""
        newContent.text = ""
        userDefault.set("", forKey: "returnAddress")
        addressBtn.setTitle("address", for: .normal)
        
        newTravelData.contentArray.removeAll()
        newTravelData.content.removeAll()
        imgsToDelete.removeAll()
        self.loadTable()
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        guard let mapVC = segue.destination as? MapViewController else { return }
        //        mapVC.address = ""
        if segue.identifier == "showMapView" {
            if let mapView = segue.destination as? MapViewController {
                if let addressBtnTitle = sender as? String {
                    mapView.address = addressBtnTitle
                }
            }
        }
    }
    
    @IBAction func getAddress(_ sender: UIStoryboardSegue) {
        //        guard let mapVC = sender.source as? MapViewController else { return }
        //        addressBtn.setTitle(mapVC.address, for: .normal)
        
    }
    
    @IBAction func changeAddress() {
        performSegue(withIdentifier: "showMapView", sender: address)
    }
    
    // deleteBtn isHidden
    @IBAction func deleteTravel() {
        if travelID != "" {
            newTravelData.contentArray = editContentArray
            newTravelData.content = editTravelInfo.content
            newTravelData.deleteData(travelID: travelID)
            
            clearContent()
        }
    }
    
}
