//
//  AddNewTypeViewController.swift
//  Keeper
//
//  Created by admin on 4/24/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class AddNewTypeViewController: UIViewController, UITextFieldDelegate {
    
    var type: Types!

    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var background: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        self.title = "Add new type"
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        border.frame = CGRect(x: 0, y: typeTextField.frame.size.height - width, width:  typeTextField.frame.size.width, height: typeTextField.frame.size.height)
        border.borderWidth = width
        typeTextField.layer.addSublayer(border)
        typeTextField.layer.masksToBounds = true
        typeTextField.textColor = UIColor.white
        typeTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(false)
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addButton(_ sender: AnyObject) {
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            type = NSEntityDescription.insertNewObject(forEntityName: "Types", into: managedObject) as? Types
            
            if typeTextField.text != "" {
                type.type = typeTextField.text!
            } else {
                let alert = UIAlertController(title: "The field is empty", message: "You need to fill this field for the start", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    

}
