//
//  AddViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class AddViewController: UIViewController {
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    fileprivate var embeddedViewController: AddNewWorkTableViewController!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var container: UIView!
    
    
    /*var pickerViewField = UIPickerView()
    var estimatePickerViewField = UIPickerView()
    var clientPickerViewField = UIPickerView()
    
    @IBOutlet weak var typeField: UITextField!
    
    @IBOutlet weak var estimateField: UITextField!
    
    var typeFieldArray = [String]()
    var clientFieldArray = [String]()
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
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
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let minR = defaults.integerForKey("minutesRow")
        let hoursR = defaults.integerForKey("hoursRow")
        let daysR = defaults.integerForKey("daysRow")
        switch pickerView {
        case pickerViewField:
            typeField.text = "\(typeFieldArray[row])"
        case estimatePickerViewField:
            switch component {
            case 0:
                defaults.setInteger(row, forKey: "daysRow")
                estimateField.text = "\((row*24)+hoursR)h \(minR)m"
            case 1:
                defaults.setInteger(row, forKey: "hoursRow")
                estimateField.text = "\((daysR*24)+hours[row])h \(minR)m"
            default:
                defaults.setInteger(row, forKey: "minutesRow")
                estimateField.text = "\(daysR*24+hoursR)h \(minutes[row])m"
            }
        case clientPickerViewField:
            clientField.text = "\(clientFieldArray[row])"
        default:
            break
        }
    }
    
    @IBAction func estimateFieldAction(sender: UITextField) {
        
        if segmentController.selectedSegmentIndex == 0 {
            sender.inputView = estimatePickerViewField
        } else {
            sender.inputView = nil
            sender.reloadInputViews()
        }
        
    }
    
    
    @IBAction func clientFieldHere(sender: UITextField) {
        
        sender.inputView = clientPickerViewField
    }
    
    
    
    @IBAction func clientFieldAction(sender: UITextField) {
        sender.inputView = clientPickerViewField
    }
    
    
    @IBAction func segmentAction(sender: AnyObject) {
        
        if segmentController.selectedSegmentIndex == 0 {
            estimateField.attributedPlaceholder = NSAttributedString(string:"Estimate", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        } else {
            
            //estimateField.resignFirstResponder()
            estimateField.inputView = nil
            estimateField.reloadInputViews()
           // estimateField.becomeFirstResponder()
            
            estimateField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(false)
        return true
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
      /*  pickerViewField.dataSource = self
        pickerViewField.delegate = self
        estimatePickerViewField.dataSource = self
        estimatePickerViewField.delegate = self
        clientPickerViewField.dataSource = self
        clientPickerViewField.delegate = self
        
        let fetchRequest = NSFetchRequest(entityName: "Types")
        
        if let managedObject = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try managedObject.executeFetchRequest(fetchRequest) as! [Types]
                if result.count > 0 {
                    for results in result {
                        typeFieldArray.append(results.type!)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        let newFetch = NSFetchRequest(entityName: "Clients")
        if let mo = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.executeFetchRequest(newFetch) as! [Clients]
                
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
        clientField.text = "Optional"
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).CGColor
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - width, width:  titleField.frame.size.width, height: titleField.frame.size.height)
        
        let secondBorder = CALayer()
        secondBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).CGColor
        secondBorder.frame = CGRect(x: 0, y: typeField.frame.size.height - width, width:  typeField.frame.size.width, height: typeField.frame.size.height)
        
        let thirdBorder = CALayer()
        thirdBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).CGColor
        thirdBorder.frame = CGRect(x: 0, y: estimateField.frame.size.height - width, width:  estimateField.frame.size.width, height: estimateField.frame.size.height)
        
        let fourthBorder = CALayer()
        fourthBorder.borderColor = UIColor(red: 121, green: 55, blue: 55, alpha: 0.1).CGColor
        fourthBorder.frame = CGRect(x: 0, y: clientField.frame.size.height - width, width:  clientField.frame.size.width, height: clientField.frame.size.height)
        
        border.borderWidth = width
        secondBorder.borderWidth = width
        thirdBorder.borderWidth = width
        fourthBorder.borderWidth = width
        
        titleField.layer.addSublayer(border)
        titleField.layer.masksToBounds = true
        titleField.tintColor = UIColor.whiteColor()
        typeField.layer.addSublayer(secondBorder)
        typeField.layer.masksToBounds = true
        typeField.tintColor = UIColor.whiteColor()
        estimateField.layer.addSublayer(thirdBorder)
        estimateField.layer.masksToBounds = true
        estimateField.tintColor = UIColor.whiteColor()
        clientField.layer.addSublayer(fourthBorder)
        clientField.layer.masksToBounds = true
        clientField.tintColor = UIColor.whiteColor()
        
        
        titleField.attributedPlaceholder = NSAttributedString(string:"Title", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        typeField.attributedPlaceholder = NSAttributedString(string:"Type of work", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        if segmentController.selectedSegmentIndex == 0 {
            estimateField.attributedPlaceholder = NSAttributedString(string:"Estimate", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        } else {
            estimateField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        clientField.attributedPlaceholder = NSAttributedString(string:"Client name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
       // pickerViewField.delegate = self
        
        self.typeField.inputView = pickerViewField
        
        if segmentController.selectedSegmentIndex == 0 {
            self.estimateField.inputView = estimatePickerViewField
        }
        
        self.clientField.inputView = clientPickerViewField
        
       // datePickerViewField.backgroundColor = UIColor.whiteColor()
        //datePickerViewField.layer.borderColor = UIColor.clearColor().CGColor
       // datePickerViewField.tintColor = UIColor.whiteColor()
        
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()

        titleField.delegate = self
        typeField.delegate = self
        estimateField.delegate = self
        clientField.delegate = self*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
    }
    
   /* func textFieldDidBeginEditing(textField: UITextField) {
            textField.placeholder = nil
    }
    
    @IBAction func titleWorkDidEndEditing(sender: UITextField) {
        
        sender.attributedPlaceholder = NSAttributedString(string:"Title", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }*/

    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.embeddedViewController.estimateField.resignFirstResponder()
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addButton(_ sender: AnyObject) {
        
        self.embeddedViewController.estimateField.resignFirstResponder()
        self.dismissKeyboard()
        
        let defaults = UserDefaults.standard
        
        let days = defaults.integer(forKey: "daysRow")
        let hours = defaults.integer(forKey: "hoursRow")
        let minutes = defaults.integer(forKey: "minutesRow")
        
        defaults.set((days*24)+hours, forKey: "estimateHours")
        defaults.set(minutes, forKey: "estimateMinutes")
        
        defaults.removeObject(forKey: "daysRow")
        defaults.removeObject(forKey: "hoursRow")
        defaults.removeObject(forKey: "minutesRow")
        
        let title = self.embeddedViewController.titleField.text
        let type = self.embeddedViewController.typeField.text
        let cName = self.embeddedViewController.clientField.text
        
        defaults.set(title, forKey: "titleOfWork")
        
        if title != "" && type != "" {
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            self.embeddedViewController.works = NSEntityDescription.insertNewObject(forEntityName: "Works", into: managedObject) as? Works
            
            if self.embeddedViewController.switchOn == true {
                
            self.embeddedViewController.works.title = title!
            self.embeddedViewController.works.type = type!
            self.embeddedViewController.works.checked = self.embeddedViewController.switchOn as NSNumber?
                if self.embeddedViewController.clientField.text == "No client" {
                    self.embeddedViewController.works.clientName = nil
                } else {
                    self.embeddedViewController.works.clientName = cName!
                }
                
                if self.embeddedViewController.segmentController.selectedSegmentIndex == 0 {
                    // если hour rate
                    
                    let estMin = minutes+((days*1440)+hours*60)
                    self.embeddedViewController.works.allTime = estMin as NSNumber?
                    let average = defaults.integer(forKey: "averagePrice")
                    self.embeddedViewController.works.money = (average*estMin)/60 as NSNumber?
                    self.embeddedViewController.works.todayTime = estMin as NSNumber?
                    self.embeddedViewController.works.fixprice = false
                    
                } else {
                    // fix
                    self.embeddedViewController.works.fixprice = true
                    if self.embeddedViewController.estimateField.text != "" {
                        self.embeddedViewController.works.money = Int(self.embeddedViewController.estimateField.text!) as NSNumber?
                    }
                    
                }
                
                if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                    let statsEnt = NSEntityDescription.insertNewObject(forEntityName: "Stats", into: mo) as? Stats
                    
                    statsEnt?.timeWorked = self.embeddedViewController.works.allTime!
                    statsEnt?.moneyEarned = self.embeddedViewController.works.money!
                    let worksComp = statsEnt?.worksCompleted as! Int
                        
                    statsEnt?.worksCompleted = NSNumber(value: worksComp+1)
                    statsEnt?.title = self.embeddedViewController.works.title!
                }
                
            } else {
                
                self.embeddedViewController.works.title = title!
                self.embeddedViewController.works.type = type!
                self.embeddedViewController.works.checked = false
                if self.embeddedViewController.clientField.text == "No client" {
                    self.embeddedViewController.works.clientName = nil
                } else {
                    self.embeddedViewController.works.clientName = cName!
                }
                
                if self.embeddedViewController.segmentController.selectedSegmentIndex == 1 {
                    
                    self.embeddedViewController.works.fixprice = true
                    self.embeddedViewController.works.futureMoney = Int(self.embeddedViewController.estimateField.text!) as NSNumber?
                    
                }
                
                if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                    let statsEnt = NSEntityDescription.insertNewObject(forEntityName: "Stats", into: mo) as? Stats
                    
                    statsEnt?.timeWorked = 0
                    statsEnt?.moneyEarned = 0
                    statsEnt?.worksCompleted = 0
                    statsEnt?.title = self.embeddedViewController.works.title!
                }
                    
        }
            
            mixpanel.track("Added new work", properties: ["Title":"\(String(describing: self.embeddedViewController.works.title))", "Type":"\(String(describing: self.embeddedViewController.works.type))", "Client name":"\(String(describing: self.embeddedViewController.works.clientName))", "Completed":"\(self.embeddedViewController.switchOn)"])
            
            do {
                try managedObject.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        } else {
            alertShow("Sorry", message: "Title and Type fields are required")
        }
        
        if self.embeddedViewController.segmentController.selectedSegmentIndex == 1 && self.embeddedViewController.estimateField.text != "" || self.embeddedViewController.segmentController.selectedSegmentIndex == 0 {
        
        if self.embeddedViewController.estimateField.text != "" && self.embeddedViewController.switchOn == false && self.embeddedViewController.segmentController.selectedSegmentIndex == 0 {
            
             mixpanel.track("Estimate", properties: ["Title":"\(self.embeddedViewController.estimateField.text!)"])
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "LoadVC")
            self.present(newVC, animated: true, completion: nil)
            
        } else {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MainTBC")
        self.present(newVC, animated: true, completion: nil)
            
        }
        } else {
            
            alertShow("No price :(", message: "Price field is required!")
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewWorkTableViewController {
            self.embeddedViewController = vc
            print("prepareForSegue")
        }
    }
    
    func alertShow(_ title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }

}
