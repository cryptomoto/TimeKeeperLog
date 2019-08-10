//
//  TimerViewController.swift
//  Keeper
//
//  Created by admin on 4/26/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

@available(iOS 9.0, *)
class TimerViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet weak var earnedLabel: UILabel!
    
    @IBOutlet weak var fullStackView: UIStackView!
    
    @IBOutlet weak var viewCircle: UIView!
    
    @IBOutlet weak var secondViewCircle: UIView!
    
    @IBOutlet weak var thirdViewCircle: UIView!
    
    let mixpanel = Mixpanel.sharedInstance(withToken: "bd7f12c679144e1ca60bb056b4017325")
    
    var alphaTimer = Timer()
    var secondAlpha = Timer()
    var thirdAlpha = Timer()
    
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    var timer = Timer()
    //var index = 0
    var oldTime: Int = 0
    var oldTodayTime: Int = 0
    var earned: Int = 0
    
    var works: Works!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCircle.alpha = 0.3
        secondViewCircle.alpha = 0.2
        thirdViewCircle.alpha = 0.1
        
        viewCircle.layer.cornerRadius = viewCircle.frame.size.width/2
        secondViewCircle.layer.cornerRadius = secondViewCircle.frame.size.width/2
        thirdViewCircle.layer.cornerRadius = thirdViewCircle.frame.size.width/2
        viewCircle.clipsToBounds = true
        secondViewCircle.clipsToBounds = true
        thirdViewCircle.clipsToBounds = true
        
        viewCircle.layer.shadowColor = UIColor(red: 118, green: 65, blue: 65, alpha: 0.5).cgColor
        viewCircle.layer.shadowOpacity = 1
        viewCircle.layer.shadowOffset = CGSize.zero
        viewCircle.layer.shadowRadius = 10
        
        secondViewCircle.layer.shadowColor = UIColor(red: 118, green: 65, blue: 65, alpha: 0.5).cgColor
        secondViewCircle.layer.shadowOpacity = 1
        secondViewCircle.layer.shadowOffset = CGSize.zero
        secondViewCircle.layer.shadowRadius = 10
        
        thirdViewCircle.layer.shadowColor = UIColor(red: 118, green: 65, blue: 65, alpha: 0.5).cgColor
        thirdViewCircle.layer.shadowOpacity = 1
        thirdViewCircle.layer.shadowOffset = CGSize.zero
        thirdViewCircle.layer.shadowRadius = 10
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 0)
        viewCircle.transform = scale.concatenating(translate)
        secondViewCircle.transform = scale.concatenating(translate)
        thirdViewCircle.transform = scale.concatenating(translate)
        fullStackView.transform = scale.concatenating(translate)
        
        let date1 = Date()
        let calendar = Calendar.current
        let date1components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: date1)
        let defaults = UserDefaults.standard
        let date2 = defaults.object(forKey: "timerClosed") as? Date
        if date2 != nil {
            let date2components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: date2!)
            if date1components.day != date2components.day {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
                if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                do {
                    let result = try managedObjectContext.fetch(fetchRequest) as! [Works]
                    for results in result {
                        results.todayTime = 0
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
        }
        }
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.Count), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    func AlphaFrame() {
        self.viewCircle.alpha-=0.01
    }
    
    func secondAlphaFrame() {
        self.secondViewCircle.alpha-=0.01
    }
    
    func thirdAlphaFrame() {
        self.thirdViewCircle.alpha-=0.01
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            self.viewCircle.transform = CGAffineTransform.identity
            self.secondViewCircle.transform = CGAffineTransform.identity
            self.thirdViewCircle.transform = CGAffineTransform.identity
            self.fullStackView.transform = CGAffineTransform.identity
            
            }, completion: nil)
        
       /* UIView.animateWithDuration(5, delay: 0, options: [], animations: { Void in
            self.secondViewCircle.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(5, delay: 0, options: [], animations: { Void in
            self.thirdViewCircle.transform = CGAffineTransformIdentity
            }, completion: nil)*/
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        //index = defaults.integerForKey("timerIndex")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
        let titleName: String = defaults.object(forKey: "titleFromWork")! as! String
        let resultPredicate = NSPredicate(format: "title = %@", "\(titleName)")
        fetchRequest.predicate = resultPredicate
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Works]
                if result.count > 0 {
                    
                let workResult = result[0]
                
                    oldTime = (Int(truncating: workResult.allTime!))*60
                    oldTodayTime = (Int(truncating: workResult.todayTime!))*60
                self.title = "\(workResult.title!)"
                
                hours = oldTime/3600
                minutes = oldTime/60-(hours*60)
                seconds = oldTime - ((hours*60)+minutes)*60
                
                earned = (oldTime/3600)*((hours*60)+minutes)
                earnedLabel.text = "you earned $\(earned)"
                
                if hours < 10 {
                    hoursLabel.text = "0\(hours)"
                } else {
                    hoursLabel.text = "\(hours)"
                }
                if minutes < 10 {
                    minutesLabel.text = "0\(minutes)"
                } else {
                    minutesLabel.text = "\(minutes)"
                }
                if seconds < 10 {
                    secondsLabel.text = "0\(seconds)"
                } else {
                    secondsLabel.text = "\(seconds)"
                }
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    @objc func Count() {
        
        let defaults = UserDefaults.standard
        //index = defaults.integerForKey("timerIndex")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
        let titleName: String = defaults.object(forKey: "titleFromWork")! as! String
        let resultPredicate = NSPredicate(format: "title = %@", "\(titleName)")
        fetchRequest.predicate = resultPredicate
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            do {
                let result = try managedObject.fetch(fetchRequest)  as! [Works]
                if result.count > 0 {
                //let workResult = result[0]
              //  oldTime = Int(workResult.allTime!)
                let averageHourRate = defaults.integer(forKey: "averagePrice")
                let interval = defaults.object(forKey: "timerOpened") as? Date
                let intervalInt = Int(Date().timeIntervalSince(interval!))+oldTime
                
                hours = intervalInt/3600
                minutes = intervalInt/60-(hours*60)
                seconds = intervalInt - ((hours*60)+minutes)*60
                
                earned = (averageHourRate*((hours*60)+minutes))/60
                earnedLabel.text = "you earned $\(earned)"
                
                if hours < 10 {
                    hoursLabel.text = "0\(hours)"
                } else {
                    hoursLabel.text = "\(hours)"
                }
                if minutes < 10 {
                    minutesLabel.text = "0\(minutes)"
                } else {
                    minutesLabel.text = "\(minutes)"
                }
                if seconds < 10 {
                    secondsLabel.text = "0\(seconds)"
                } else {
                    secondsLabel.text = "\(seconds)"
                }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    @IBAction func stopWorking(_ sender: AnyObject) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Works")
        
        if let managedObject = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            let defaults = UserDefaults.standard
            
            let timerOpened = defaults.object(forKey: "timerOpened") as? Date
            let workInterval = Int(Date().timeIntervalSince(timerOpened!))//+oldTime
            
            let titleName: String = defaults.object(forKey: "titleFromWork")! as! String
            let resultPredicate = NSPredicate(format: "title = %@", "\(titleName)")
            fetchRequest.predicate = resultPredicate
            
            do {
                let result = try managedObject.fetch(fetchRequest) as! [Works]
                if result.count > 0 {
                let currentWork = result[0]
                currentWork.allTime = ((workInterval+oldTime)/60 as NSNumber?)
                    print("\(workInterval)")
                currentWork.money = earned as NSNumber?
                    let date1 = Date()
                    let calendar = Calendar.current
                    let date1components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: date1)
                    let defaults = UserDefaults.standard
                    let date2 = defaults.object(forKey: "timerOpened") as? Date
                    if date2 != nil {
                        let date2components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: date2!)
                        if date1components.day == date2components.day {
                            currentWork.todayTime = (workInterval+oldTodayTime)/60 as NSNumber?
                        } else {
                            currentWork.todayTime = 0
                        }
                    }
                
                mixpanel.track("Timer stoped", properties: ["Time":"\(workInterval/60)","Earned":"$\(earned)"])
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
                request.predicate = resultPredicate
                let results = try managedObject.fetch(request) as! [Stats]
                    let resultObject = results[0]
                resultObject.timeWorked = NSNumber(value: workInterval/60)
                    resultObject.moneyEarned = earned as NSNumber?
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            do {
                try managedObject.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "openTimer")
        defaults.set(Date(), forKey: "timerClosed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MainTBC")
        self.present(newVC, animated: true, completion: nil)
        //self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
