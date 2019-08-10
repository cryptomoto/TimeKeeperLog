//
//  ContactViewController.swift
//  Keeper
//
//  Created by admin on 7/3/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, ContainerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    fileprivate var embeddedVC: ContactFormTableViewController!
    
    @IBOutlet weak var userpicView: UIImageView!
    
    @IBOutlet weak var pickAvaButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var background: UIImageView!
    
    
    var clients: Clients!
    
    var editEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
       /* if clients != nil {
        if clients.photo != nil {
            userpicView.image = UIImage(data:clients.photo!)
            userpicView.layer.cornerRadius = userpicView.frame.size.width/2
            userpicView.layer.masksToBounds = true
            userpicView.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 180.0)
        }
        }*/
        
        imagePicker.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        containerView.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pickAvatar(_ sender: AnyObject) {
        
       /* imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)*/
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            userpicView.contentMode = .scaleToFill
            userpicView.layer.cornerRadius = userpicView.frame.width / 2
            userpicView.layer.masksToBounds = true
            userpicView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func editButton(_ sender: AnyObject) {
        
       /* if editEnabled == false {
            editEnabled = true
            
            deleteButtonView.hidden = false
            deleteButton.hidden = false
            clientEmailField.enabled = true
            phoneNumberField.enabled = true
            
            editButton.setTitle("Save", forState: .Normal)
            doneButton.hidden = true
            
        } else {
            editEnabled = false
            
            if let mo = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                clients.email = clientEmailField.text!
                
            }
            
            deleteButtonView.hidden = true
            deleteButton.hidden = true
            clientEmailField.enabled = false
            phoneNumberField.enabled = false
            
            editButton.setTitle("Edit", forState: .Normal)
            doneButton.hidden = false
            
        }*/
        
    }

    
    
    func closeAllTextFields(_ first: UITextField, second: UITextField, third: UITextField, fourth: UITextField) {
        first.isEnabled = false
        second.isEnabled = false
        third.isEnabled = false
        fourth.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! ContactFormTableViewController
        destVC.delegate = self
        self.embeddedVC = destVC
        
    }
    
    func realWorking() {
        print("its working!")
    }

}

extension UIImage {
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let normalizedPicture = UIGraphicsGetImageFromCurrentImageContext()
        
        return normalizedPicture!
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
