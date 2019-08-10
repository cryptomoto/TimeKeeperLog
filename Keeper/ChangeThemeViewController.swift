//
//  ChangeThemeViewController.swift
//  Keeper
//
//  Created by admin on 4/25/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class ChangeThemeViewController: UIViewController {
    
    @IBOutlet weak var switcher: UISwitch!
    
    @IBOutlet weak var background: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change theme"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        let theme = defaults.bool(forKey: "theme")
        
        if theme == true {
            switcher.isOn = true
            self.background.image = UIImage(named: "background.png")
        } else {
            switcher.isOn = false
            self.background.image = UIImage(named: "background2.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchTheme(_ sender: AnyObject) {
        
        if switcher.isOn {
            switcher.isOn = true
            self.background.image = UIImage(named: "background.png")
        } else {
            switcher.isOn = false
            self.background.image = UIImage(named: "background2.png")
        }
        
    }
    
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        if switcher.isOn == true {
            defaults.set(true, forKey: "theme")
        } else {
            defaults.set(false, forKey: "theme")
        }
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }

   
    
    
    
}
