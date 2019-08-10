//
//  ClientsViewController.swift
//  Keeper
//
//  Created by admin on 5/15/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class ClientsViewController: UIViewController {
    
    var clients: Clients!
    
    fileprivate var embeddedViewController: ClientsTableViewController!
    
    @IBOutlet weak var noClientsImage: UIImageView!
    
    @IBOutlet weak var noClientsText: UILabel!
    
    @IBOutlet weak var hideThisView: UIView!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var containerWithTable: UIView!
    
    @IBOutlet weak var addButtonLayout: UIBarButtonItem!
    
    @IBOutlet weak var doneButtonLayout: UIBarButtonItem!
    
    override func viewDidLayoutSubviews() {
        
     /*   let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        border.frame = CGRect(x: 0, y: nameField.frame.size.height - width, width:  nameField.frame.size.width, height: nameField.frame.size.height)
        
        border.borderWidth = width
        nameField.layer.addSublayer(border)
        nameField.layer.masksToBounds = true
        
        let secondBorder = CALayer()
        let secondWidth = CGFloat(1.0)
        secondBorder.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        secondBorder.frame = CGRect(x: 0, y: companyField.frame.size.height - secondWidth, width:  companyField.frame.size.width, height: companyField.frame.size.height)
        
        secondBorder.borderWidth = secondWidth
        companyField.layer.addSublayer(secondBorder)
        companyField.layer.masksToBounds = true
        
        let thirdBorder = CALayer()
        let thirdWidth = CGFloat(1.0)
        thirdBorder.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        thirdBorder.frame = CGRect(x: 0, y: emailField.frame.size.height - thirdWidth, width:  emailField.frame.size.width, height: emailField.frame.size.height)
        
        thirdBorder.borderWidth = thirdWidth
        emailField.layer.addSublayer(thirdBorder)
        emailField.layer.masksToBounds = true*/
        
    }
    
    override func viewDidLoad() {
        
        hideThisView.backgroundColor = UIColor.clear
        
       /* let tap = UITapGestureRecognizer(target: self, action: #selector(ClientsViewController.handleTap(_:)))
        tap.delegate = self
        viewBack.addGestureRecognizer(tap)
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(ClientsViewController.hideKeyBoard))
        self.view.addGestureRecognizer(hideKeyboard)
        
        self.nameField.delegate = self
        self.companyField.delegate = self
        self.emailField.delegate = self*/
        
        //initializeGestureRecognizer()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
            noClientsImage.image = noClientsImage.image!.withRenderingMode(.alwaysTemplate)
            noClientsImage.tintColor = UIColor.white
            noClientsImage.alpha = 0.5
            noClientsText.textColor = UIColor.white
            noClientsText.alpha = 0.5
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Clients")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(fetchRequest) as! [Clients]
                if result.count > 0 {
                    hideThisView.isHidden = true
                } else {
                    hideThisView.isHidden = false
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        containerWithTable.backgroundColor = UIColor.clear
        
      /*  viewBack.backgroundColor = UIColor.blackColor()
        
        viewAdd.layer.cornerRadius = 5
        viewAdd.hidden = true
        viewBack.hidden = true*/
        
        //containerWithTable.backgroundColor = UIColor.clearColor()
        
        //viewBack.alpha = 0
        //viewBack.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        
     /*   let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        viewAdd.transform = CGAffineTransformConcat(scale, translate)*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Clients")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(fetchRequest) as! [Clients]
                if result.count > 0 {
                    hideThisView.isHidden = true
                } else {
                    hideThisView.isHidden = false
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
   /* func initializeGestureRecognizer()
    {
        //For PanGesture Recoginzation
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ClientsViewController.handleTap(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        viewAdd.addGestureRecognizer(panGesture)
    }*/
    
    override func didReceiveMemoryWarning() {
        
        
    }
    
   /* func handleTap(sender: UIGestureRecognizer? = nil) {
        UIView.animateWithDuration(1, delay: 0, options: [], animations: { Void in
            
            self.viewAdd.alpha = 0
            self.viewBack.alpha = 0
            self.addButtonLayout.enabled = true
            self.doneButtonLayout.enabled = true
            self.dismissKeyboard()
            
            }, completion: nil)
    }*/
    
   /* func viewAppears() {
        
        self.viewBack.alpha = 0
        self.viewBack.hidden = false
        self.addButtonLayout.enabled = false
        self.doneButtonLayout.enabled = false
    
        UIView.animateWithDuration(1, delay: 0, options: [], animations: { Void in
            self.viewAdd.alpha = 1
            self.viewAdd.transform = CGAffineTransformIdentity
            self.viewBack.alpha = 0.8
            }, completion: nil)
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ClientsTableViewController {
            self.embeddedViewController = vc
            print("prepareForSegue")
        }
    }
    
    /*@IBAction func addButton(sender: AnyObject) {
        
        if nameField.text != nil && emailField.text != nil && nameField.text != "" && emailField.text != "" {
        if let mo = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            clients = NSEntityDescription.insertNewObjectForEntityForName("Clients", inManagedObjectContext: mo) as! Clients
                clients.name = nameField.text!
                clients.email = emailField.text!
                if companyField.text != "" {
                    clients.company = companyField.text!
                }
                
                do {
                    try mo.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
        
        self.embeddedViewController.forVC()
        
        nameField.text = ""
        companyField.text = ""
        emailField.text = ""
        
        UIView.animateWithDuration(1, delay: 0, options: [], animations: { Void in
            
            self.viewAdd.alpha = 0
            self.viewBack.alpha = 0
            
            self.addButtonLayout.enabled = true
            self.doneButtonLayout.enabled = true
            self.dismissKeyboard()
            
            }, completion: nil)
            
            let fetchRequest = NSFetchRequest(entityName: "Clients")
                do {
                    let result = try mo.executeFetchRequest(fetchRequest) as! [Clients]
                    if result.count > 0 {
                        hideThisView.hidden = true
                    } else {
                        hideThisView.hidden = false
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
        
            }
        } else {
            let alert = UIAlertController(title: "Required", message: "Sorry, all fields are required to fill", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    */
    
    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addClientButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "contactVC")
        self.present(newVC, animated: true, completion: nil)
        
    }
    
    
}
