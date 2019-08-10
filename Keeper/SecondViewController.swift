//
//  SecondViewController.swift
//  Keeper
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var viewToHide: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
viewToHide.isHidden = true
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
