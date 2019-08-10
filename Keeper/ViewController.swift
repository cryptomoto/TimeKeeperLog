//
//  ViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var yourAverage: UILabel!
    
    @IBOutlet weak var youWorked: UILabel!
    
    @IBOutlet weak var youEarned: UILabel!
    
    @IBOutlet weak var noWorksImage: UIImageView!
    
    @IBOutlet weak var noWorksText: UILabel!
    
    var works: [Works] = []
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var segmentWork: UISegmentedControl!
    
    @IBOutlet weak var noWorkYet: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var embeddedViewController: MainTableViewController!
    
    var timer = Timer()
    
    var allTime = 0
    var allMoney = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.ReloadThis), userInfo: nil, repeats: true)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        containerView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        let hideWorks = defaults.bool(forKey: "hideWorks")
        if hideWorks == true {
            segmentWork.selectedSegmentIndex = 0
        } else {
            segmentWork.selectedSegmentIndex = 1
        }
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
            noWorksImage.image = noWorksImage.image!.withRenderingMode(.alwaysTemplate)
            noWorksImage.tintColor = UIColor.white
            noWorksImage.alpha = 0.5
            noWorksText.textColor = UIColor.white
            noWorksText.alpha = 0.5
            
        }
        
        let average = defaults.integer(forKey: "averagePrice")
        if average > 999 {
            self.yourAverage.text = "$\(average/1000)k"
        } else {
            self.yourAverage.text = "$\(average)"
        }
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Works]
                if result.count > 0 {
                    noWorkYet.isHidden = true
                    var allSum: Int = 0
                    var allSumMoney:Int = 0
                    
                    for results in result {
                        if results.allTime != nil {
                            allTime = results.allTime as! Int
                        }
                        
                        if results.money != nil {
                            allMoney = results.money as! Int
                        }
                        
                        allSum += allTime
                        allSumMoney += allMoney
                        
                        let allHours = allSum/60
                        let allMinutes = allSum - (60*(allSum/60))
                        
                        if allSumMoney > 999 && allSumMoney < 99999 {
                            self.youEarned.text = "$\(allSumMoney/1000)k"
                        } else if allSumMoney > 9999 {
                            self.youEarned.text = "$\(allSumMoney/1000000)kk"
                        } else {
                            self.youEarned.text = "$\(allSumMoney)"
                        }
                        
                        if allTime < 59 {
                            self.youWorked.text = "\(allSum)m"
                        } else {
                            if allMinutes == 0 {
                                if allHours > 24 {
                                    let dopHours = allHours-((allHours/24)*24)
                                    if dopHours == 0 {
                                        self.youWorked.text = "\(allHours/24)d"
                                    } else {
                                        self.youWorked.text = "\(allHours/24)d \(dopHours)h"
                                    }
                                } else {
                                    let dopMinutes = allSum - (allSum/60)*60
                                    if dopMinutes == 0 {
                                        self.youWorked.text = "\(allHours)h"
                                    } else {
                                        self.youWorked.text = "\(allHours)h \(dopMinutes)m"
                                    }
                                }
                            } else {
                                if allHours > 24 {
                                    let dopHours = allHours-((allHours/24)*24)
                                    if dopHours == 0 {
                                        self.youWorked.text = "\(allHours/24)d"
                                    } else {
                                        self.youWorked.text = "\(allHours/24)d \(dopHours)h"
                                    }
                                } else {
                                    let dopMinutes = allSum - (allSum/60)*60
                                    if dopMinutes == 0 {
                                        self.youWorked.text = "\(allHours)h"
                                    } else {
                                        self.youWorked.text = "\(allHours)h \(dopMinutes)m"
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    noWorkYet.isHidden = false
                    noWorkYet.backgroundColor = UIColor.clear
                    self.youWorked.text = "0m"
                    self.youEarned.text = "$0"
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedWorkAction(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        
        if segmentWork.selectedSegmentIndex == 0 {
            
            defaults.set(true, forKey: "hideWorks")
            self.embeddedViewController.fetchData()
            
        } else {
            
            defaults.set(false, forKey: "hideWorks")
            self.embeddedViewController.fetchDataWithCompleted()
            
        }
        
        self.embeddedViewController.ReloadTV()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? MainTableViewController {
            
            self.embeddedViewController = vc
        }
    }
    

    @objc func ReloadThis() {
        let defaults = UserDefaults.standard
        
        let average = defaults.integer(forKey: "averagePrice")
        if average > 999 {
            self.yourAverage.text = "$\(average/1000)k"
        } else {
            self.yourAverage.text = "$\(average)"
        }
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Works]
                if result.count > 0 {
                    noWorkYet.isHidden = true
                    var allSum: Int = 0
                    var allSumMoney:Int = 0
                    
                    for results in result {
                        
                        if results.allTime != nil {
                            allTime = results.allTime as! Int
                        }
                        
                        if results.money != nil {
                            allMoney = results.money as! Int
                        }
                        
                        allSum += allTime
                        allSumMoney += allMoney
                        let allHours = allSum/60
                        let allMinutes = allSum - (60*(allSum/60))
                        
                        if allSumMoney > 999 && allSumMoney < 99999 {
                            self.youEarned.text = "$\(allSumMoney/1000)k"
                        } else if allSumMoney > 9999 {
                            self.youEarned.text = "$\(allSumMoney/1000000)kk"
                        } else {
                            self.youEarned.text = "$\(allSumMoney)"
                        }
                        
                        if allSum < 59 {
                            self.youWorked.text = "\(allSum)m"
                        } else {
                            if allMinutes == 0 {
                                if allHours > 24 {
                                    let dopHours = allHours-((allHours/24)*24)
                                    if dopHours == 0 {
                                        self.youWorked.text = "\(allHours/24)d"
                                    } else {
                                        self.youWorked.text = "\(allHours/24)d \(dopHours)h"
                                    }
                                } else {
                                    let dopMinutes = allSum - (allSum/60)*60
                                    if dopMinutes == 0 {
                                    self.youWorked.text = "\(allHours)h"
                                    } else {
                                       self.youWorked.text = "\(allHours)h \(dopMinutes)m"
                                    }
                                }
                            } else {
                                if allHours > 24 {
                                    let dopHours = allHours-((allHours/24)*24)
                                    if dopHours == 0 {
                                        self.youWorked.text = "\(allHours/24)d"
                                    } else {
                                        self.youWorked.text = "\(allHours/24)d \(dopHours)h"
                                    }
                                } else {
                                    let dopMinutes = allSum - (allSum/60)*60
                                    if dopMinutes == 0 {
                                        self.youWorked.text = "\(allHours)h"
                                    } else {
                                        self.youWorked.text = "\(allHours)h \(dopMinutes)m"
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    noWorkYet.isHidden = false
                    noWorkYet.backgroundColor = UIColor.clear
                    self.youWorked.text = "0m"
                    self.youEarned.text = "$0"
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func addButton(_ sender: AnyObject) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Types")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(fetchRequest) as! [Types]
                if result.count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "AddViewC")
                    self.present(newVC, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Types are required", message: "Firstly, you need to add at least one type", preferredStyle: .alert)
                    let firstAction = UIAlertAction(title: "Add", style: .default, handler: ({ (ACTION) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let newVC = storyboard.instantiateViewController(withIdentifier: "secondPage")
                        self.present(newVC, animated: true, completion: nil)
                    }))
                    alert.addAction(firstAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    

}

