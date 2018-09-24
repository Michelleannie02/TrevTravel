//
//  ChangeLanguage.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-24.
//  Copyright © 2018 TrevTravel. All rights reserved.
//

import UIKit

class ChangeLanguage: UIViewController {

    @IBOutlet weak var changeToZH: UIButton!
    @IBOutlet weak var changeToEN: UIButton!
    @IBOutlet weak var changeToSV: UIButton!
    
    @IBOutlet weak var currentLan: UILabel!
    
    //var currentLanguage = NSLocale.current.languageCode
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func clickZH() {
//        currentLan.text = "home".localizableSstring("zh-Hans")
//        Bundle.main.onLanguage()
        changeLanguage("zh-Hans")
    }
    
    @IBAction func clickEN() {
        changeLanguage("en")
    }
    
    @IBAction func clickSV() {
        changeLanguage("sv")
    }
    


    
    
    func changeLanguage(_ lan: String) {
        // 切换语言前
        let langArr1 = UserDefaults.standard.value(forKey: "AppleLanguages") as? [Any]
        let language1 = langArr1?.first as? String
        print("*********** Language before changing: \(language1 ?? "")  ***********")
        
        // 切换语言
        let lans = [lan]
        UserDefaults.standard.set(lans, forKey: "AppleLanguages")
        
        // 切换语言后
        let langArr2 = UserDefaults.standard.value(forKey: "AppleLanguages") as? [Any]
        let language2 = langArr2?.first as? String
        print("*********** Language changed to: \(language2 ?? "")  ***********")
        
        showChangedLanguage(lan)
//        buttonColorOfCurrentLanguage(lan)
        
        // 重新设置rootViewController
//        refreshView()
        
    }
    
    func showChangedLanguage(_ lan:String) {
        var remindText = ""
        remindText += "showChangedLanguage".localizableSstring(lan)
        remindText += lan.localizableSstring(lan)
        
        currentLan.text = remindText
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

    func localizableSstring(_ loc: String) -> String {
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
