//
//  Settings.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class Settings: UIViewController {
    
    @IBOutlet weak var userEmailBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var currentLanguageBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    
    var logInStatus:String = ""
    
    // connect to UserDefaults for System Preferences
    let userDefault = UserDefaults.standard
    
    let login:String = NSLocalizedString("login", comment: "")
    let logout:String = NSLocalizedString("logout", comment: "")
    let guest:String = NSLocalizedString("guest", comment: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        changeLangBtn.setTitle(NSLocalizedString("change", comment: ""), for: .normal)
        // Set the language bar current Language
        let lang = userDefault.string(forKey: "appLanguage") ?? "en"
        
        currentLanguageBtn.setTitle(getLanguageName(lang), for: .normal)
        
        // loginBtn shows "log out" when logged in, otherwise shows "log in"
        // Check log in status
        logInStatus = Auth.auth().currentUser?.email! ?? guest
        print("apper loginstatus: \(logInStatus)")
        
        print("logInStatus: \(logInStatus)")
        if logInStatus == guest {
            // When no user is logged in
            loginBtn.setTitle(login, for: .normal)
        } else {
            // when a user is logged in
            loginBtn.setTitle(logout, for: .normal)
        }
        userEmailBtn.setTitle(logInStatus, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func LoginOrLogout(_ sender: Any) {
        if logInStatus != guest {
            // when logged in, this is a function for signing out
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Firebase signed out")
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
            print("logInStatus1: \(logInStatus)")
            logInStatus = ""
            print("logInStatus2: \(logInStatus)")
            let temp = Auth.auth().currentUser?.email ?? guest
            print("temp: \(temp)")


            // change user bar status as a guest
            userEmailBtn.setTitle(logInStatus, for: .normal)
            loginBtn.setTitle(logout, for: .normal)
            
        }

        // When no user log in, no function
        
    }
    
    func getLanguageName(_ lang:String) -> String {
        var returnName = ""
        var setLang = ""
        if lang.prefix(2) == "zh" {
            setLang = "zh-Hans"
        } else {
            setLang = lang
        }
        
        switch setLang {
        case "zh-Hans":
            returnName = "zh-Hans".localizableString(setLang)
        case "sv":
            returnName = "sv".localizableString(setLang)
        default:
            returnName = "en".localizableString(setLang)
        }
        print("getLanguage: \(lang, setLang, returnName)")
        return returnName
    }
//
//    func showUserName(_ name:String) -> String {
//        var username = ""
//        if name == "" {
//            username = "Guest"
//        } else {
//            username = ""
//        }
//
//        return username
//    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let language = segue.destination as? ChangeLanguage else { return }
        print("prepare override function")
        
    }

    @IBAction func back(_ sender: UIStoryboardSegue) {
//        guard let language = sender.source as? ChangeLanguage else { return }
        print("back function")
    }

    
}
