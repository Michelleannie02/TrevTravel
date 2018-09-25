//
//  Login.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class Login: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginUser:String = Auth.auth().currentUser?.email ?? "Guest"
    
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        if Auth.auth().currentUser != nil {
            // User is signed in
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let uEmail = user.email
            }
        } else {
            // No user is signed in
            print("No user is logged in")
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.placeholder = "Email"
        self.passwordTextField.placeholder = "password"

        print("Login Email: \(loginUser)")
        
        
        
//        let status: String = UserDefaults.standard.string(forKey: "logInStatus")!
//        if status != "" {
//            print(status)
//        } else {
//            print("no status data")
//        }
        
        // Load "logInStatus" from memory
//        UserDefaults.standard.string(forKey: "logInStatus")
        
    }
    
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if user != nil {
                self.reminder("\(self.emailTextField.text ?? "Success!") has signed up! You can log in now")
                self.clearInputText(textField: self.emailTextField)
                self.clearInputText(textField: self.passwordTextField)
            }
            if error != nil {
                self.reminder("This email is already registered!")
                self.clearInputText(textField: self.passwordTextField)
            }
        }
        
    }
    
    @IBAction func signin(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if user != nil {
                self.reminder("You have signed in!")
                self.clearInputText(textField: self.emailTextField)
                self.clearInputText(textField: self.passwordTextField)
                

                print("New Login Email: \(Auth.auth().currentUser?.email ?? "No user")")
                

                // Save "logInStatus" to memory
//                UserDefaults.standard.set(self.emailTextField.text, forKey: "logInStatus")
//                print(self.emailTextField.text!)
            }
            if error != nil {
                self.reminder("Email or password incorrect!")
                self.clearInputText(textField: self.passwordTextField)
            }
        }
        
    }
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        print("resetPasswordBtn")
//        Auth.auth().sendPasswordReset(withEmail: ) { (error) in
//
//        }
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
