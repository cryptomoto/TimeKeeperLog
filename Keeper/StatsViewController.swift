//
//  StatsViewController.swift
//  Keeper
//
//  Created by admin on 5/5/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController {
    
    @IBOutlet weak var youWorked: UILabel!
    
    @IBOutlet weak var youEarned: UILabel!
    
    @IBOutlet weak var worksCompleted: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    
   // var clearTimer = NSTimer()
    
    var completedWorks = 0
    var compWorks = 0
    var totalTime = 0
    var totalMoney = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "STATS"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Stats]
                
                if result.count > 0 {
                    for results in result {
                        
                        compWorks+=results.worksCompleted as! Int
                        totalTime+=results.timeWorked as! Int
                        totalMoney+=results.moneyEarned as! Int
                        
                        if compWorks < 0 {
                            compWorks = 0
                            results.worksCompleted = 0
                        }
                        
                        if totalTime < 0 {
                            totalTime = 0
                            results.timeWorked = 0
                        }
                        
                        if totalMoney < 0 {
                            totalMoney = 0
                            results.moneyEarned = 0
                        }
                        
                    }
                    
                    worksCompleted.text = "\(compWorks)"
                    
                    if totalTime > 59 {
                        let totalHours = totalTime/60
                        let totalMin = totalTime-((totalTime/60)*60)
                        if totalMin == 0 {
                            youWorked.text = "\(totalHours)h"
                        } else {
                            youWorked.text = "\(totalHours)h \(totalMin)m"
                        }
                        
                        if totalHours > 24 {
                            let totalDays = totalHours/24
                            let dopHours = totalHours - ((totalHours/24)*24)
                            if dopHours == 0 {
                                youWorked.text = "\(totalDays)d"
                            } else {
                                youWorked.text = "\(totalDays)d \(dopHours)h"
                            }
                        }
                        
                    } else {
                        youWorked.text = "\(totalTime)m"
                    }
                    
                    youEarned.text = "$\(totalMoney)"
                    
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
    

    @IBAction func clearStats(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "If you will tap \"Yes\" if will clear all stats. Are you sure?", preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Yes", style: .default, handler: ({ (ACTION) in
            
            self.clearTimerNow()
            
        }))
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertActionOk)
            alert.addAction(alertActionCancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    func clearTimerNow() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
        if let mo = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                let result = try mo.fetch(fetchRequest) as! [Stats]
                if result.count > 0 {

                    for results in result {
                        results.timeWorked = 0
                        results.moneyEarned = 0
                        results.worksCompleted = 0
                        self.youWorked.text = "\(results.timeWorked!)m"
                        self.youEarned.text = "$\(results.moneyEarned!)"
                        self.worksCompleted.text = "\(results.worksCompleted!)"
                }
                }
                
                do {
                    try mo.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    

}
