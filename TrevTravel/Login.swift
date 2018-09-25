//
//  Login.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth


class Login: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var hasLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.placeholder = "Email"
        self.password.placeholder = "password"
        
    }
    
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if user != nil {
                self.reminder("\(self.email.text ?? "Success!") has signed up! You can log in now")
                self.clearInputText(textField: self.email)
                self.clearInputText(textField: self.password)
            }
            if error != nil {
                self.reminder("This email is already registered!")
                self.clearInputText(textField: self.password)
            }
        }
        
    }
    
    @IBAction func signin(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if user != nil {
                self.reminder("You have signed in!")
                self.clearInputText(textField: self.email)
                self.clearInputText(textField: self.password)
                self.hasLoggedIn = true
            }
            if error != nil {
                self.reminder("Email or password incorrect!")
                self.clearInputText(textField: self.password)
            }
        }
        
    }
    
    
    
    func reminder(_ msg:String) {
        let alert = UIAlertController(title: "Reminder", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("********** default **********")
            case .cancel:
                print("********** cancel **********")
            case .destructive:
                print("********** destructive **********")
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func clearInputText(textField: UITextField) {
        textField.text = ""
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
