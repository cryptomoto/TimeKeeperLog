//
//  NotificaitonsViewController.swift
//  Keeper
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import Mixpanel
import UserNotifications

class NotificaitonsViewController: UIViewController {
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.backgroundImage.image = UIImage(named: "background.png")
        } else {
            self.backgroundImage.image = UIImage(named: "background2.png")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func setButton(_ sender: AnyObject) {
        
        for local in UIApplication.shared.scheduledLocalNotifications! {
        
            if local.category! == "Notify" {
                UIApplication.shared.cancelLocalNotification(local)
            }
            
        }
        
        let locals = UILocalNotification()
        locals.alertBody = "Don't forget to work today!"
        locals.alertTitle = "Working time"
        locals.fireDate = pickerDate.date
        locals.repeatInterval = .day
        locals.applicationIconBadgeNumber+=1
        locals.category = "Notify"
        
        UIApplication.shared.scheduleLocalNotification(locals)
        
        let alert = UIAlertController(title: "Success", message: "Notification successfully added", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: ({
            (ACTION) in
            let _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    


}
