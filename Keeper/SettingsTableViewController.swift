//
//  SettingsTableViewController.swift
//  Keeper
//
//  Created by admin on 4/24/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import MessageUI
import Social

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var hourRateCell: UITableViewCell!
    
    @IBOutlet weak var typesOfWorkCell: UITableViewCell!
    
    @IBOutlet weak var clientsCell: UITableViewCell!
    
    @IBOutlet weak var StatsCell: UITableViewCell!

    @IBOutlet weak var notificationsCell: UITableViewCell!
    
    @IBOutlet weak var askCell: UITableViewCell!
    
    @IBOutlet weak var cellToHide: UITableViewCell!
    
    @IBOutlet weak var shareCell: UITableViewCell!
    
    
    var hourRateSum: Int = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Reloader()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        } else {
            tableView.separatorColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.1)
        }
        
     //   tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        tableView.backgroundColor = UIColor.clear
        hourRateCell.backgroundColor = UIColor.clear
        typesOfWorkCell.backgroundColor = UIColor.clear
        StatsCell.backgroundColor = UIColor.clear
        clientsCell.backgroundColor = UIColor.clear
        notificationsCell.backgroundColor = UIColor.clear
        cellToHide.isHidden = true
        askCell.backgroundColor = UIColor.clear
        hourRateCell.tintColor = UIColor(red:0, green: 0, blue: 0, alpha: 0.2)
        shareCell.backgroundColor = UIColor.clear
        
        hourRateCell.textLabel?.text = "Hour-rate"
        
        hourRateCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        typesOfWorkCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        clientsCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        StatsCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        askCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        notificationsCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        shareCell.textLabel?.textColor = UIColor(red: 158, green: 69, blue: 69, alpha: 1)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.Reloader()
        
    }

    func Reloader() {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kzntsv888@icloud.com"])
            mail.setSubject("Keeper")
            
            present(mail, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failure", message: "Failure while sending a message", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let secondAlertAction = UIAlertAction(title: "Retry", style: .default, handler: ({ (ACTION) in
                self.sendEmail()
            }))
            alert.addAction(alertAction)
            alert.addAction(secondAlertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Thank you!", message: "We will be very glad if you tell your friends about us", preferredStyle: .alert)
        let twitAction = UIAlertAction(title: "Share on Twitter", style: .default, handler: ({ (ACTION) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText("I am using @keeper_app to work harder! Join us!")
                
                let url = URL(fileURLWithPath: "http://bit.ly/KeeperApp")
                twitterSheet.add(url)
                
                self.present(twitterSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        let fbAction = UIAlertAction(title: "Share on Facebook", style: .default, handler: ({ (ACTION) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("I am using Keeper app to work harder! Join us!")
                
                    let url = URL(fileURLWithPath: "http://bit.ly/KeeperApp")
                    facebookSheet.add(url)
                
                self.present(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(twitAction)
        alert.addAction(fbAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func askQuestion(_ sender: AnyObject) {
        
        self.sendEmail()
        
    }
    
    @IBAction func emptyButton(_ sender: AnyObject) {
        
        self.sendEmail()
        
    }
    
}
