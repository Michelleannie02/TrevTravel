//
//  Settings.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {
    
    @IBOutlet weak var userEmailBtn: UIButton!
    @IBOutlet weak var currentLanguageBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    
    var logInStatus:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = NSLocale.current.languageCode
        
        // Set the language bar current Language
        currentLanguageBtn.setTitle(getLanguageName(lang!), for: .normal)
        
        // loginBtn shows "log out" when logged in, otherwise shows "log in"
        logInStatus = Auth.auth().currentUser?.email! ?? "Guest"
        print("logInStatus: \(logInStatus)")
        if logInStatus == "Guest" {
            // When no user is logged in
            loginBtn.setTitle("Log in", for: .normal)
        } else {
            // when a user is logged in
            loginBtn.setTitle("Log out", for: .normal)
        }
        userEmailBtn.setTitle(logInStatus, for: .normal)
        
    }
    
    
    @IBAction func LoginOrLogout(_ sender: Any) {
        if logInStatus == "Guest" {
            loginBtn.setTitle("Log out", for: .normal)
        }
        
    }
    
    func getLanguageName(_ lang:String) -> String {
        var returnName = ""
        switch lang {
        case "zh-Hans":
            returnName = "zh-Hans".localizableSstring("zh-Hans")
        case "sv":
            returnName = "sv".localizableSstring("sv")
        default:
            returnName = "en".localizableSstring("en")
        }
        return returnName
    }
    
    func showUserName(_ name:String) -> String {
        var username = ""
        if name == "" {
            username = "Guest"
        } else {
            username = ""
        }
        
        return username
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
