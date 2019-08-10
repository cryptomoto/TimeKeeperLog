//
//  ContactFormTableViewController.swift
//  Keeper
//
//  Created by admin on 7/7/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class ContactFormTableViewController: UITableViewController {
    
    var delegate: ContainerProtocol?
    
    var client: Clients!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var companyField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var nameCell: UITableViewCell!
    
    @IBOutlet weak var companyCell: UITableViewCell!
    
    @IBOutlet weak var emailCell: UITableViewCell!
    
    @IBOutlet weak var phoneCell: UITableViewCell!
    
    @IBOutlet weak var saveCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        client = self.delegate?.clients
        
        if client != nil {
            
            nameField.text = client.name!
            if client.company != nil {
                companyField.text = client.company!
            } else {
                companyField.text = ""
            }
            if client.email != nil {
                emailField.text = client.email!
            } else {
                emailField.text = ""
            }
            if client.phone != nil {
                phoneField.text = client.phone!
            } else {
                phoneField.text = ""
            }
        }
        
        nameCell.backgroundColor = UIColor.clear
        companyCell.backgroundColor = UIColor.clear
        emailCell.backgroundColor = UIColor.clear
        phoneCell.backgroundColor = UIColor.clear
        saveCell.backgroundColor = UIColor.clear

        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        nameLabel.alpha = 0.5
        companyLabel.alpha = 0.5
        emailLabel.alpha = 0.5
        phoneLabel.alpha = 0.5

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        border.frame = CGRect(x: 0, y: nameField.frame.size.height - width, width:  nameField.frame.size.width, height: nameField.frame.size.height)
        
        let secondBorder = CALayer()
        secondBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        secondBorder.frame = CGRect(x: 0, y: companyField.frame.size.height - width, width:  companyField.frame.size.width, height: companyField.frame.size.height)
        
        let thirdBorder = CALayer()
        thirdBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        thirdBorder.frame = CGRect(x: 0, y: emailField.frame.size.height - width, width:  emailField.frame.size.width, height: emailField.frame.size.height)
        
        let fourthBorder = CALayer()
        fourthBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        fourthBorder.frame = CGRect(x: 0, y: phoneField.frame.size.height - width, width:  phoneField.frame.size.width, height: phoneField.frame.size.height)
        
        
        border.borderWidth = width
        secondBorder.borderWidth = width
        thirdBorder.borderWidth = width
        fourthBorder.borderWidth = width
        
        nameField.layer.addSublayer(border)
        nameField.layer.masksToBounds = true
        nameField.tintColor = UIColor.white
        
        companyField.layer.addSublayer(secondBorder)
        companyField.layer.masksToBounds = true
        companyField.tintColor = UIColor.white
        
        emailField.layer.addSublayer(thirdBorder)
        emailField.layer.masksToBounds = true
        emailField.tintColor = UIColor.white
        
        phoneField.layer.addSublayer(fourthBorder)
        phoneField.layer.masksToBounds = true
        phoneField.tintColor = UIColor.white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        if nameField.text?.isEmptyField == false {
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            if client == nil {
                client = NSEntityDescription.insertNewObject(forEntityName: "Clients", into: mo) as? Clients
                client.name = nameField.text!
                if companyField.text == "" {
                    client.company = nil
                } else {
                    client.company = companyField.text!
                }
                
                if emailField.text?.isEmptyField == true {
                    client.email = nil
                } else {
                    client.email = emailField.text!
                }
                
                if phoneField.text?.isEmptyField == true {
                    client.phone = nil
                } else {
                    client.phone = phoneField.text!
                }
                
            } else {
                client.name = nameField.text!
                if companyField.text?.isEmptyField == true {
                    client.company = nil
                } else {
                    client.company = companyField.text!
                }
                
                if emailField.text?.isEmptyField == true {
                    client.email = nil
                } else {
                   client.email = emailField.text!
                }
                
                if phoneField.text?.isEmptyField == true {
                    client.phone = nil
                } else {
                    client.phone = phoneField.text!
                }
            }
            
            do {
                try mo.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Name field is empty", message: "This field is required", preferredStyle: .alert)
            let firstAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(firstAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
}

protocol ContainerProtocol {
    func realWorking()
    var clients: Clients! { get set }
    var userpicView: UIImageView! { get set }
}

extension String {
    var isEmptyField: Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
}
