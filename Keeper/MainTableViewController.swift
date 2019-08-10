//
//  MainTableViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class MainTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    var work: Works!
    var works: [Works] = []
    
    var allTime = 0
    var allMoney = 0
    var todayTime = 0
    
    var typeOfWork = String()
    
    var appDel = UIApplication.shared.delegate as! AppDelegate
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
        } else {
            tableView.separatorColor = UIColor(white: 1, alpha: 0.1)
        }
        
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let hideWorks = defaults.bool(forKey: "hideWorks")
        
        if hideWorks == true {
            self.fetchData()
        } else {
            self.fetchDataWithCompleted()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ReloadTV()
        
        let defaults = UserDefaults.standard
        let hideWorks = defaults.bool(forKey: "hideWorks")
        
        if hideWorks == true {
            self.fetchData()
        } else {
            self.fetchDataWithCompleted()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredWorks = works.filter({$0.checked == 1})
        let newFitler = works.filter({$0.checked == 0})
        
        let defaults = UserDefaults.standard
        let hideWorks = defaults.bool(forKey: "hideWorks")
        if hideWorks == true {
            print("filteredcount - \(filteredWorks.count)")
            print("hideWorksTrue")
            return works.count - filteredWorks.count
        } else {
            print("hideWorksFalse")
            return works.count - newFitler.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell", for: indexPath) as! WorkTableViewCell

        cell.selectionStyle = .none
        cell.backView.layer.cornerRadius = 3
        cell.backgroundColor = UIColor.clear
        cell.titleLabel.text = works[indexPath.row].title
        if works[indexPath.row].clientName == "" || works[indexPath.row].clientName == nil {
            cell.typeLabel.text = works[indexPath.row].type
        } else {
            cell.typeLabel.text = "\(works[indexPath.row].type!) for \(works[indexPath.row].clientName!)"
        }
        
        if works[indexPath.row].allTime != nil {
            allTime = (Int(truncating: works[indexPath.row].allTime!))
        }
        
        if works[indexPath.row].money != nil {
            allMoney = (Int(truncating: works[indexPath.row].money!))
        }
        
        if works[indexPath.row].todayTime != nil {
            todayTime = (Int(truncating: works[indexPath.row].todayTime!))
        }
        
        let minutes = allTime - ((allTime/60)*60)
        
        if works[indexPath.row].checked?.boolValue == true {
            
            if allTime > 0 && allTime < 59 {
                
            cell.statsLabel.text = "Total time: \(minutes)m / $\(allMoney)"
            } else if allTime == 0 {
                cell.statsLabel.text = "Total time: 0m / $\(allMoney)"
            } else {
                if minutes == 0 {
                    cell.statsLabel.text = "Total time: \(allTime/60)h / $\(allMoney)"
                } else {
                    cell.statsLabel.text = "Total time: \(allTime/60)h \(minutes)m / $\(allMoney)"
                }
            }

            cell.titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            cell.typeLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            cell.statsLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            //cell.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            cell.backView.backgroundColor = UIColor.clear
            
            } else {
   
            if allTime > 0 && allTime < 59 {
                if minutes == 0 {
                    cell.statsLabel.text = "Today: \(todayTime)m / $\(allMoney)"
                } else {
                    cell.statsLabel.text = "Today: \(todayTime)m / Total: \(minutes)m / $\(allMoney)"
                }
            } else if allTime == 0 {
                cell.statsLabel.text = "Today: 0m / Total: 0m / $\(allMoney)"
            } else {
                if minutes == 0 {
                    cell.statsLabel.text = "Today: \(todayTime/60)h / Total: \(allTime/60)h / $\(allMoney)"
                } else {
                    cell.statsLabel.text = "Today: \(todayTime/60)h / Total: \(allTime/60)h \(minutes)m / $\(allMoney)"
                }
            }
           // cell.titleLabel.textColor = UIColor.whiteColor()
           // cell.typeLabel.textColor = UIColor.whiteColor()
           // cell.statsLabel.textColor = UIColor.whiteColor()
                //cell.backView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
                cell.backView.backgroundColor = UIColor.clear
            }
        
        if works[indexPath.row].fixprice == true {
            if works[indexPath.row].futureMoney != nil {
                let futureMoney = works[indexPath.row].futureMoney
                cell.statsLabel.text = "Fixed payment $\(futureMoney!)"
            } else {
                cell.statsLabel.text = "Fixed payment $\(allMoney)"
            }
        }
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            if works[indexPath.row].checked?.boolValue == true {
                cell.titleLabel.textColor = UIColor.white
                cell.typeLabel.textColor = UIColor.white
                cell.statsLabel.textColor = UIColor.white
                cell.titleLabel.alpha = 0.5
                cell.typeLabel.alpha = 0.5
                cell.statsLabel.alpha = 0.5
            } else {
                cell.titleLabel.textColor = UIColor.white
                cell.typeLabel.textColor = UIColor.white
                cell.statsLabel.textColor = UIColor.white
                cell.titleLabel.alpha = 1
                cell.typeLabel.alpha = 1
                cell.statsLabel.alpha = 1
            }
        } else {
            if works[indexPath.row].checked?.boolValue == true {
                cell.titleLabel.textColor = UIColor.white
                cell.typeLabel.textColor = UIColor.white
                cell.statsLabel.textColor = UIColor.white
                cell.titleLabel.alpha = 0.5
                cell.typeLabel.alpha = 0.5
                cell.statsLabel.alpha = 0.5
            } else {
                cell.titleLabel.textColor = UIColor.white
                cell.typeLabel.textColor = UIColor.white
                cell.statsLabel.textColor = UIColor.white
                cell.titleLabel.alpha = 1
                cell.typeLabel.alpha = 1
                cell.statsLabel.alpha = 1
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Choose what you want to do", message: nil, preferredStyle: .actionSheet)
        
        if works[indexPath.row].checked?.boolValue == true {
            typeOfWork = "Uncomplete"
        } else {
            typeOfWork = "Complete"
        }
        
        let zeroAction = UIAlertAction(title: typeOfWork, style: .default, handler: ({ void in
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
            let resultPredicate = NSPredicate(format: "title = %@", "\(self.works[indexPath.row].title!)")
            fetchRequest.predicate = resultPredicate
            if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                do {
                    let result = try managedObject.fetch(fetchRequest) as! [Stats]
                    if result.count > 0 {
                        let currentResult = result[0]
                        if self.works[indexPath.row].checked?.boolValue == false {
                            self.works[indexPath.row].checked = true
                            let worksOld = Int(truncating: currentResult.worksCompleted!) + 1
                            currentResult.worksCompleted = worksOld as NSNumber?
                            let initial = self.works[indexPath.row]
                            
                            print("COMPLETED")
                            
                            if initial.fixprice == true {
                                initial.money = initial.futureMoney
                            }
                        } else {
                            self.works[indexPath.row].checked = false
                            let worksOld = Int(truncating: currentResult.worksCompleted!) - 1
                            currentResult.worksCompleted = worksOld as NSNumber?
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                /*if self.works[indexPath.row].checked?.boolValue == false {
                    self.works[indexPath.row].checked = true
                    let worksOld = Int(self.works[indexPath.row].statsWorksCompleted!) + 1
                    self.works[indexPath.row].statsWorksCompleted = worksOld
                } else {
                    self.works[indexPath.row].checked = false
                   // let worksOld = Int(self.works[indexPath.row].statsWorksCompleted!) - 1
                    //self.works[indexPath.row].statsWorksCompleted = worksOld
                }*/
                
                do {
                    try managedObject.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                self.fetchData()
                tableView.reloadData()
            }
            
        }))
        
        let firstAction = UIAlertAction(title: "Start working", style: .default, handler: ({ void in
            
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "timerOpened")
            //defaults.setInteger(indexPath.row, forKey: "timerIndex")
            defaults.set(self.works[indexPath.row].title, forKey: "titleFromWork")
            defaults.set(true, forKey: "openTimer")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "TimerVC")
            self.present(newVC, animated: true, completion: nil)
            
        }))
        let secondAction = UIAlertAction(title: "Delete", style: .default, handler: ({ void in
            
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                let rowsToDelete = self.fetchedResultsController.object(at: indexPath) as! Works
                managedObjectContext.delete(rowsToDelete)
                self.works.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("deleted")
                do {
                    try managedObjectContext.save()
                } catch {
                    print("error")
                }
                self.fetchData()
            }
            
        }))
        let thirdAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
       // let worksIndex = works[indexPath.row]

        if self.works[indexPath.row].fixprice.boolValue == false {
            alertController.addAction(firstAction)
        }
        alertController.addAction(zeroAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func ReloadTV() {
        tableView.reloadData()
    }
    
    @IBAction func addNew(_ sender: AnyObject) {
        
        ReloadTV()
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            do {
                try managedObject.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
        
        let sortDescriptor = NSSortDescriptor(key: "checked", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
                works = fetchedResultsController.fetchedObjects as! [Works]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDataWithCompleted() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
        
        let sortDescriptor = NSSortDescriptor(key: "checked", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
                fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
                works = fetchedResultsController.fetchedObjects as! [Works]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

}
