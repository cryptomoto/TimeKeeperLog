//
//  SettingsViewController.swift
//  Keeper
//
//  Created by admin on 4/24/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var containterView: UIView!
    
    @IBOutlet weak var background: UIImageView!
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        segmentControl.tintColor = UIColor.white
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            segmentControl.selectedSegmentIndex = 0
            self.background.image = UIImage(named: "background.png")
        } else {
            segmentControl.selectedSegmentIndex = 1
            self.background.image = UIImage(named: "background2.png")
        }

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        containterView.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        
        let defaults = UserDefaults.standard
        
        if segmentControl.selectedSegmentIndex == 0 {
            self.background.image = UIImage(named: "background.png")
            defaults.set(true, forKey: "theme")
        } else {
            self.background.image = UIImage(named: "background2.png")
            defaults.set(false, forKey: "theme")
        }
        
    }
    
    

}
