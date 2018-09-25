//
//  Settings.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var userEmailBtn: UIButton!
    @IBOutlet weak var currentLanguageBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var changeLangBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = NSLocale.current.languageCode
        currentLanguageBtn.setTitle(getLanguageName(lang!), for: .normal)
        
        userEmailBtn.setTitle(showUserName(""), for: .normal)
        
        // loginBtn 在有登录时显示log out, 否则显示 log in
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
