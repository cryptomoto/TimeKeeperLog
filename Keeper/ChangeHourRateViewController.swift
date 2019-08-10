//
//  ChangeHourRateViewController.swift
//  Keeper
//
//  Created by admin on 4/24/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import Mixpanel

class ChangeHourRateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var hourRateField: UITextField!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var textSpecified: UILabel!
    
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
            textSpecified.textColor = UIColor.white
            textSpecified.alpha = 0.5
        }
        
        self.title = "Hour-rate"
        hourRateField.text = "\(defaults.integer(forKey: "averagePrice"))"
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        border.frame = CGRect(x: 0, y: hourRateField.frame.size.height - width, width: hourRateField.frame.size.width, height: hourRateField.frame.size.height)
        border.borderWidth = width
        hourRateField.layer.addSublayer(border)
        hourRateField.layer.masksToBounds = true
        hourRateField.textColor = UIColor.white
        hourRateField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(false)
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButton(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        defaults.set(Int(hourRateField.text!)!, forKey: "averagePrice")
        
        mixpanel.track("Hour-rate changed", properties: ["New hour-rate":"\(defaults.integer(forKey: "averagePrice"))"])
    
        self.navigationController!.popViewController(animated: true)
        
    }


}
