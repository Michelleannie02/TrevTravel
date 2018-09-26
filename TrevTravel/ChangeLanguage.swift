//
//  ChangeLanguage.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class ChangeLanguage: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var changeToZH: UIButton!
    @IBOutlet weak var changeToEN: UIButton!
    @IBOutlet weak var changeToSV: UIButton!
    
    @IBOutlet weak var currentLan: UILabel!
    
    // connect to UserDefaults for System Preferences
    let userDefault = UserDefaults.standard
    /*
     1. initiate:
        let userDefault = UserDefaults.standard
     2. set data to UserDefaults:
        userDefault.set("abc", forKey: "abc")
        userDefault.set(123, forKey: "def")
     3.  get data from UserDefaults:
        userDefault.string(forKey: "abc")
        userDefault.integer(forKey: "def")
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add this line for back function
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        currentLan.alpha = 0.0
    }
    
    
    
    @IBAction func clickZH() {
//        currentLan.text = "home".localizableString("zh-Hans")
//        Bundle.main.onLanguage()
        changeLanguage("zh-Hans")
//        self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    @IBAction func clickEN() {
        changeLanguage("en")
    }
    
    @IBAction func clickSV() {
        changeLanguage("sv")
    }
    
//    @IBAction func back(segue: UIStoryboardSegue) {
//        print("closed")
//    }

    
    
    func changeLanguage(_ lan: String) {
        // Current Language before changing
        let langArr1 = userDefault.value(forKey: "AppleLanguages") as? [Any]
        let language1 = langArr1?.first as? String
        
        // Changing
        let lans = [lan]
        userDefault.set(lans, forKey: "AppleLanguages")
        
        // Changed current Language
        let langArr2 = userDefault.value(forKey: "AppleLanguages") as? [Any]
        let language2 = langArr2?.first as? String
        print("*********** Language change: \(language1 ?? "") → \(language2 ?? "")")
        print("lan: \(lan)")
        
        userDefault.set(lan, forKey: "appLanguage")
        showChangedLanguage(language1!, lan)
//        buttonColorOfCurrentLanguage(lan)
        
    }
    
    func showChangedLanguage(_ previousLan:String, _ changedLan:String) {
        var remindText = ""
        remindText += "showChangedLanguage".localizableString(previousLan)
        remindText += changedLan.localizableString(previousLan)
        
        currentLan.alpha = 1.0
        currentLan.text = remindText
        // Disappear text after 1 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            UIView.animate(withDuration: 1.0, animations: {
//                self.currentLan.text = ""
//            })
//        }
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.currentLan.alpha = 0.0
        })
        
        
    }
    
    func buttonColorOfCurrentLanguage(_ lan:String) {
        switch lan {
        case "zh-Hans":
            darkColorBtn(self.changeToZH)
            lightColorBtn(self.changeToEN)
            lightColorBtn(self.changeToSV)
        case "sv":
            darkColorBtn(self.changeToSV)
            lightColorBtn(self.changeToEN)
            lightColorBtn(self.changeToZH)
        default:
            darkColorBtn(self.changeToEN)
            lightColorBtn(self.changeToZH)
            lightColorBtn(self.changeToSV)
        }
    }
    
    func darkColorBtn(_ btn: UIButton) {
        btn.backgroundColor = UIColor(red: 126, green: 65, blue: 41, alpha: 1)
    }
    func lightColorBtn(_ btn: UIButton) {
        btn.backgroundColor = UIColor(red: 255, green: 230, blue: 182, alpha: 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
//
//    func refreshView() {
//        // dismiss all viewControllers
//        guard let vc = self.presentingViewController else {
//            return
//        }
//        while (vc.presentingViewController != nil) {
//            vc.dismiss(animated: true, completion: nil)
//        }
//    }
    

}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

public extension String {

    func localizableString(_ loc: String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////






//
//
//enum Language : String {
//    case english = "en"
//    case chinese = "zh-Hans"
//    case swedish = "sv"
//}
//
//
//
//
///**
// *  当调用onLanguage后替换掉mainBundle为当前语言的bundle
// */
//
//class BundleEx: Bundle {
//
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        if let bundle = Bundle.getLanguageBundle() {
//            return bundle.localizedString(forKey: key, value: value, table: tableName)
//        }else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
//    }
//}
//
//
//extension Bundle {
//
//    private static var onLanguageDispatchOnce: ()->Void = {
//        //替换Bundle.main为自定义的BundleEx
//        object_setClass(Bundle.main, BundleEx.self)
//    }
//
//    func onLanguage(){
//        Bundle.onLanguageDispatchOnce()
//    }
//
//    class func getLanguageBundle() -> Bundle? {
//        let languageBundlePath = Bundle.main.path(forResource: NSLocale.current.languageCode, ofType: "lproj")
//
//        print("*******************************************")
//        print("path = \(languageBundlePath ?? "")")
//        print("*******************************************")
//
//        guard languageBundlePath != nil else {
//            return nil
//        }
//
//        let languageBundle = Bundle.init(path: languageBundlePath!)
//        guard languageBundle != nil else {
//            return nil
//        }
//
//        return languageBundle!
//
//    }
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
