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
    
    let emailPlaceholder:String = NSLocalizedString("email", comment: "")
    let passwordPlaceholder:String = NSLocalizedString("password", comment: "")
    let reminder:String = NSLocalizedString("reminder", comment: "")
    let okBtn:String = NSLocalizedString("ok", comment: "")
    let loginError:String = NSLocalizedString("loginerror", comment: "")
    let loginsuccess:String = NSLocalizedString("loginsuccess", comment: "")
    let signuperror:String = NSLocalizedString("signuperror", comment: "")
    let signupsuccess:String = NSLocalizedString("signupsuccess", comment: "")

    
    
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
            print("No user logged in")
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.placeholder = emailPlaceholder
        self.passwordTextField.placeholder = passwordPlaceholder

        print("Login Email: \(loginUser)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        print("move distance: \(-screenWidth * 33 / 64)")
        
        if UIDevice.current.orientation.isLandscape {
            UIView.animate(withDuration: 0.0, delay: 0.0, options: [], animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -screenWidth * 33 / 64)
            })
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if user != nil {
                self.reminder(self.signupsuccess)
                self.clearInputText(textField: self.emailTextField)
                self.clearInputText(textField: self.passwordTextField)
            }
            if error != nil {
                self.reminder(self.signuperror)
                self.clearInputText(textField: self.passwordTextField)
            }
        }
        
    }
    
    @IBAction func signin(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if user != nil {
                self.reminder(self.loginsuccess)
                self.clearInputText(textField: self.emailTextField)
                self.clearInputText(textField: self.passwordTextField)
                

                print("New Login Email: \(Auth.auth().currentUser?.email ?? "No user")")
                

            }
            if error != nil {
                self.reminder(self.loginError)
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
    
    @IBAction func googleLogin(_ sender: Any) {
        
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
    }
    
    
    func reminder(_ msg:String) {
        let alert = UIAlertController(title: reminder, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtn, style: .default, handler: { action in
            switch action.style {
            case .default:
//                var delegate: Settings!
//                delegate.back(UIStoryboardSegue)
                
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
    
    

}
