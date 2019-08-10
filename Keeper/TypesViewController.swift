//
//  TypesViewController.swift
//  Keeper
//
//  Created by admin on 4/24/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class TypesViewController: UIViewController {
    
    var type: Types!
    
    @IBOutlet weak var containerView: UIView!
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    @IBOutlet weak var background: UIImageView!
    
    fileprivate var embeddedViewController: TypesTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        containerView.backgroundColor = UIColor.clear
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TypesViewController.AddNew))
        navigationItem.rightBarButtonItem = addButton
        self.title = "Types"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func AddNew() {
        let alert = UIAlertController(title: "Add new type", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Type here"
        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: ({ void in
            if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let textField = alert.textFields![0] as UITextField
                self.type = (NSEntityDescription.insertNewObject(forEntityName: "Types", into: managedObject) as! Types)
                self.type.type = textField.text!
                self.mixpanel.track("Type added", properties: ["Type title":"\(String(describing: self.type.type))"])
                self.dismissKeyboard()
                do {
                    try managedObject.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                self.embeddedViewController.forVC()
            }
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TypesTableViewController {
            self.embeddedViewController = vc
            print("prepareForSegue")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
    }

}
