//
//  AddNewWorkTableViewController.swift
//  Keeper
//
//  Created by admin on 6/25/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class AddNewWorkTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var hideCell: UITableViewCell!
    
    @IBOutlet weak var titleCell: UITableViewCell!
    
    @IBOutlet weak var typeCell: UITableViewCell!
    
    @IBOutlet weak var estimateCell: UITableViewCell!
    
    @IBOutlet weak var clientCell: UITableViewCell!
    
    @IBOutlet weak var completedOrNotCell: UITableViewCell!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeField: UITextField!
    
    @IBOutlet weak var estimateLabel: UILabel!
    
    @IBOutlet weak var estimateField: UITextField!
    
    @IBOutlet weak var clientLabel: UILabel!

    @IBOutlet weak var clientField: UITextField!
    
    @IBOutlet weak var workStatusSwitcher: UISwitch!
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    var switchOn = false
    
    var cost: Int = 0
    
    var works: Works!
    
    var estimate = 0
    
    var daysRow = 0
    var hoursRow = 0
    var minutesRow = 0
    
    var days = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    var hours = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var minutes = [0,5,10,15,20,25,30,35,40,45,50,55]
    
    var pickerViewField = UIPickerView()
    var estimatePickerViewField = UIPickerView()
    var clientPickerViewField = UIPickerView()
    
    var typeFieldArray = [String]()
    var clientFieldArray = ["No client"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case pickerViewField:
            return 1
        case estimatePickerViewField:
            return 3
        case clientPickerViewField:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        switch pickerView {
        case pickerViewField:
            return typeFieldArray.count
        case estimatePickerViewField:
            switch component {
            case 0:
                return days.count
            case 1:
                return hours.count
            default:
                return minutes.count
            }
        case clientPickerViewField:
            return clientFieldArray.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerViewField:
            return "\(typeFieldArray[row])"
        case estimatePickerViewField:
            switch component {
            case 0:
                return "\(days[row])"
            case 1:
                return "\(hours[row])"
            default:
                return "\(minutes[row])"
            }
        case clientPickerViewField:
            return "\(clientFieldArray[row])"
        default:
            return "\(typeFieldArray[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = UserDefaults.standard
        let minR = defaults.integer(forKey: "minutesRow")
        let hoursR = defaults.integer(forKey: "hoursRow")
        let daysR = defaults.integer(forKey: "daysRow")
        switch pickerView {
        case pickerViewField:
            typeField.text = "\(typeFieldArray[row])"
        case estimatePickerViewField:
            switch component {
            case 0:
                defaults.set(row, forKey: "daysRow")
                estimateField.text = "\((row*24)+hoursR)h \(minR)m"
            case 1:
                defaults.set(row, forKey: "hoursRow")
                estimateField.text = "\((daysR*24)+hours[row])h \(minR)m"
            default:
                defaults.set(row, forKey: "minutesRow")
                estimateField.text = "\(daysR*24+hoursR)h \(minutes[row])m"
            }
        case clientPickerViewField:
            clientField.text = "\(clientFieldArray[row])"
        default:
            break
        }
    }
    
    @IBAction func estimateFieldAction(_ sender: UITextField) {
        
        if segmentController.selectedSegmentIndex == 0 {
            sender.inputView = estimatePickerViewField
        } else {
            sender.inputView = nil
            sender.reloadInputViews()
        }
        
    }
    
    
    @IBAction func clientFieldHere(_ sender: UITextField) {
        
        sender.inputView = clientPickerViewField
    }
    
    @IBAction func clientFieldStarted(_ sender: UITextField) {
        
        
        if clientFieldArray.isEmpty == true {
            let alert = UIAlertController(title: "No clients", message: "Go to settings to add new clients", preferredStyle: .alert)
            let action = UIAlertAction(title: "Settings", style: .default, handler: ({ (ACTION) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let settingsVC = storyboard.instantiateViewController(withIdentifier: "ClientsVC")
                self.present(settingsVC, animated: true, completion: nil)
            }))
            let secondAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            alert.addAction(secondAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func clientFieldAction(_ sender: UITextField) {
        
        sender.inputView = clientPickerViewField
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.alpha = 0.5
        typeLabel.alpha = 0.5
        estimateLabel.alpha = 0.5
        clientLabel.alpha = 0.5
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        hideCell.backgroundColor = UIColor.clear
        titleCell.backgroundColor = UIColor.clear
        typeCell.backgroundColor = UIColor.clear
        estimateCell.backgroundColor = UIColor.clear
        clientCell.backgroundColor = UIColor.clear
        completedOrNotCell.backgroundColor = UIColor.clear

        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == false {
            workStatusSwitcher.onTintColor = UIColor.white
        }
        
        pickerViewField.dataSource = self
        pickerViewField.delegate = self
        estimatePickerViewField.dataSource = self
        estimatePickerViewField.delegate = self
        clientPickerViewField.dataSource = self
        clientPickerViewField.delegate = self
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Types]
                if result.count > 0 {
                    for results in result {
                        typeFieldArray.append(results.type!)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        let newFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Clients")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(newFetch) as! [Clients]
                
                if result.count > 0 {
                    for results in result {
                        clientFieldArray.append(results.name!)
                    }
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        typeField.text = typeFieldArray[0]
        //clientField.text = "Optional"
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - width, width:  titleField.frame.size.width, height: titleField.frame.size.height)
        
        let secondBorder = CALayer()
        secondBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        secondBorder.frame = CGRect(x: 0, y: typeField.frame.size.height - width, width:  typeField.frame.size.width, height: typeField.frame.size.height)
        
        let thirdBorder = CALayer()
        thirdBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        thirdBorder.frame = CGRect(x: 0, y: estimateField.frame.size.height - width, width:  estimateField.frame.size.width, height: estimateField.frame.size.height)
        
        let fourthBorder = CALayer()
        fourthBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).cgColor
        fourthBorder.frame = CGRect(x: 0, y: clientField.frame.size.height - width, width:  clientField.frame.size.width, height: clientField.frame.size.height)
        
        border.borderWidth = width
        secondBorder.borderWidth = width
        thirdBorder.borderWidth = width
        fourthBorder.borderWidth = width
        
        titleField.layer.addSublayer(border)
        titleField.layer.masksToBounds = true
        titleField.tintColor = UIColor.white
        typeField.layer.addSublayer(secondBorder)
        typeField.layer.masksToBounds = true
        typeField.tintColor = UIColor.white
        estimateField.layer.addSublayer(thirdBorder)
        estimateField.layer.masksToBounds = true
        estimateField.tintColor = UIColor.white
        clientField.layer.addSublayer(fourthBorder)
        clientField.layer.masksToBounds = true
        clientField.tintColor = UIColor.white
        
        
        titleField.attributedPlaceholder = NSAttributedString(string:"Title", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        
        typeField.attributedPlaceholder = NSAttributedString(string:"Type of work", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        
        if segmentController.selectedSegmentIndex == 0 {
            estimateField.attributedPlaceholder = NSAttributedString(string:"Estimate", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        } else {
            estimateField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        }
        
        clientField.attributedPlaceholder = NSAttributedString(string:"Client name", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        
        // pickerViewField.delegate = self
        
        self.typeField.inputView = pickerViewField
        
        if segmentController.selectedSegmentIndex == 0 {
            self.estimateField.inputView = estimatePickerViewField
        }
        
        if clientFieldArray.isEmpty != true {
            self.clientField.inputView = clientPickerViewField
        } else {
            self.clientField.inputView = nil
        }
        
        self.hideKeyboardWhenTappedAround()
        
        titleField.delegate = self
        typeField.delegate = self
        estimateField.delegate = self
        clientField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Clients")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(newFetch) as! [Clients]
                
                if result.count > 0 {
                    for results in result {
                        clientFieldArray.append(results.name!)
                    }
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        if clientFieldArray.isEmpty == false {
            clientField.text = clientFieldArray[0]
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if clientFieldArray.isEmpty == false {
            clientField.text = clientFieldArray[0]
        }
        
    }
    
    @IBAction func switcherWork(_ sender: AnyObject) {
        
        if workStatusSwitcher.isOn == true {
            workStatusSwitcher.isOn = true
            switchOn = true
        } else {
            workStatusSwitcher.isOn = false
            switchOn = false
        }
        
    }
    
    @IBAction func titleWorkDidEndEditing(_ sender: UITextField) {
        
        sender.attributedPlaceholder = NSAttributedString(string:"Title here", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        
    }
    
    func alertShow(_ title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentAction(_ sender: AnyObject) {
        
        if segmentController.selectedSegmentIndex == 0 {
            
            estimateField.inputView = estimatePickerViewField
            
            estimateField.attributedPlaceholder = NSAttributedString(string:"Estimate", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))

                estimateLabel.text = "Estimate"
                self.dismissKeyboard()
            
        } else {
            
            estimateLabel.text = "Price"
            
            //estimateField.resignFirstResponder()
            
            self.dismissKeyboard()
            
            estimateField.keyboardType = UIKeyboardType.numberPad
            estimateField.inputView = nil
            estimateField.reloadInputViews()
            // estimateField.becomeFirstResponder()
            
            estimateField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white]))
        }
        
    }

  /*  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
