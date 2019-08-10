//
//  ThirdViewController.swift
//  Keeper
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var viewToHide: UIView!
    
    @IBOutlet weak var beginButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewToHide.isHidden = true
        self.view.backgroundColor = UIColor.clear
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0, y: 500)
        beginButton.transform = scale.concatenating(translate)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.beginButton.transform = CGAffineTransform.identity
            }, completion: nil)
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "hideWorks")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
