//
//  HoursRateViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class HoursRateViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var hoursRate: UITextField!
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    var averagePrice: AveragePrice!
    
    let limitLength = 5
    
    override func viewDidLayoutSubviews() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.2).cgColor
        border.frame = CGRect(x: 0, y: hoursRate.frame.size.height - width, width:  hoursRate.frame.size.width, height: hoursRate.frame.size.height)
        
        border.borderWidth = width
        hoursRate.layer.addSublayer(border)
        hoursRate.layer.masksToBounds = true
        hoursRate.tintColor = UIColor(red: 121, green: 55, blue: 55, alpha: 1)
        hoursRate.textColor = UIColor.white
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        hoursRate.delegate = self
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "theme")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    
    @IBAction func goFuther(_ sender: AnyObject) {
        
        if hoursRate.text?.isEmpty == true {
            let alert = UIAlertController(title: nil, message: "You need to write your hour-rate", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {

            let averagePrice = Int(hoursRate.text!)
            let defaults = UserDefaults.standard
            defaults.set(averagePrice!, forKey: "averagePrice")
                    
            }
            
        mixpanel.track("First hour-rate", properties: ["Hour-Rate":"\(String(describing: Int(hoursRate.text!)))"])
        }
        
    }
