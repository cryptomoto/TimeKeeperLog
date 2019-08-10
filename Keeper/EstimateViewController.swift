//
//  EstimateViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Mixpanel

class EstimateViewController: UIViewController {
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    @IBOutlet weak var dollarIcon: UIImageView!
    
    @IBOutlet weak var estimateText: UILabel!
    
    @IBOutlet weak var estimateSecondText: UILabel!
    
    @IBOutlet weak var viewToHide: UIView!
    
    @IBOutlet weak var workName: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var titleWork = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        viewToHide.backgroundColor = UIColor.clear
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
            dollarIcon.image = dollarIcon.image!.withRenderingMode(.alwaysTemplate)
            dollarIcon.tintColor = UIColor.white
            estimateText.textColor = UIColor.white
            estimateSecondText.textColor = UIColor.white
            estimateText.alpha = 0.5
            estimateSecondText.alpha = 0.5
            
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white

        titleWork = defaults.object(forKey: "titleOfWork") as! String
        workName.text = "Work \"\(titleWork)\" will cost"
        let price = defaults.integer(forKey: "averagePrice")
        let time = ((defaults.integer(forKey: "estimateHours")*60)+defaults.integer(forKey: "estimateMinutes"))
        priceLabel.text = "$\((price*time)/60)"
        let hours = defaults.integer(forKey: "estimateHours")
        let minutes = defaults.integer(forKey: "estimateMinutes")
        if defaults.integer(forKey: "estimateMinutes") == 0 {
            timeLabel.text = "and it will take about \(hours) hours"
        } else if hours == 0 {
            timeLabel.text = "and it will take about \(minutes)m"
        } else {
            timeLabel.text = "and it will take about \(hours)h \(minutes)m"
        }
        
        mixpanel.track("EstimateViewController", properties: ["Title":"\(titleWork)","Price":"\((price*time)/60)", "Hour-rate":"\(price)", "Time(minutes)":"\(hours*60+minutes)"])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendCustomer(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        let price = defaults.integer(forKey: "averagePrice")
        let time = ((defaults.integer(forKey: "estimateHours")*60)+defaults.integer(forKey: "estimateMinutes"))
        let cost = (price*time)/60
        var string = String()
        
        let hours = defaults.integer(forKey: "estimateHours")
        let minutes = defaults.integer(forKey: "estimateMinutes")
        if defaults.integer(forKey: "estimateMinutes") == 0 && defaults.integer(forKey: "estimateHours") > 0 {
            switch defaults.integer(forKey: "estimateHours") {
            case 1:
               string = "This work will cost $\(cost) and it will take about \(hours) hour"
            default:
                string = "This work will cost $\(cost) and it will take about \(hours) hours"
            }
        } else if hours == 0 {
            string = "This work will cost $\(cost) and it will take about \(minutes) minutes"
        } else {
            string = "This work will cost $\(cost) and it will take about \(hours) hours \(minutes) minutes"
        }
        
        let activityViewController = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        self.present(activityViewController, animated: true) {
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.mail, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.message, UIActivity.ActivityType.copyToPasteboard]
        }
        
    }
    
    @IBAction func skipScreen(_ sender: AnyObject) {
        
        self.close()

        
    }
    
    func close() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MainTBC")
        self.present(newVC, animated: true, completion: nil)
    }
    

}
