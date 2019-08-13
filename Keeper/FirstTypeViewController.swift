//
//  FirstTypeViewController.swift
//  Keeper
//
//  Created by admin on 4/26/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class FirstTypeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var type: Types!

    fileprivate var embeddedViewController: FirstTypeTableViewController!
    
    var appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        containerView.backgroundColor = UIColor.clear
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FirstTypeViewController.AddNew))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func AddNew() {
        let alert = UIAlertController(title: "Add new type", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Type here"
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: ({ void in
            if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let textField = alert.textFields![0] as UITextField
                self.type = NSEntityDescription.insertNewObject(forEntityName: "Types", into: managedObject) as? Types
                self.type.type = textField.text!
                self.dismissKeyboard()
                self.typeView.isHidden = true
                self.startButton.isHidden = false
            
                self.mixpanel.track("First type", properties: ["Type title":"\(self.type.type!)"])
                
                do {
                    try managedObject.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                self.dismissKeyboard()
                self.embeddedViewController.forVC()
            }
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FirstTypeTableViewController {
            self.embeddedViewController = vc
            print("prepareForSegue")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Types]
                if result.count > 0 {
                    //fetchRequest.propertiesToFetch = ["Title"]
                    typeView.isHidden = true
                    startButton.isHidden = false
                } else {
                    typeView.isHidden = false
                    startButton.isHidden = true
                    typeView.backgroundColor = UIColor.clear
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func startKeeper(_ sender: AnyObject) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Types]
                if result.count > 0 {
                    print("\(result)")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "MainTBC")
                    self.present(newVC, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Types are empty", message: "You need to add at least one type", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    

}
