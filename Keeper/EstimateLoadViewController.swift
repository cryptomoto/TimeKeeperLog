//
//  EstimateLoadViewController.swift
//  Keeper
//
//  Created by admin on 4/23/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class EstimateLoadViewController: UIViewController {
    
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var flipContainer: UIView!
    
    @IBOutlet weak var flipView: CDFlipView!
    
    var timer = Timer()
    var seconds:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }

        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(EstimateLoadViewController.Wait), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func Wait() {
        
        flipView.stopAnimation()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "EstimateVC")
        self.present(newVC, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "theme") == true {
            self.background.image = UIImage(named: "background.png")
        } else {
            self.background.image = UIImage(named: "background2.png")
        }
        
        var imageSet:[UIImageView] = [] // use any object of type UIView
        
        for index in 1...2{
            let image = UIImageView(image: UIImage(named: "\(index)"))
            image.contentMode = .scaleAspectFill
            imageSet.append(image)
        }
        
        flipView.layer.zPosition = 100
        flipView.durationForOneTurnOver = 0.6
        flipView.stillTime = 0.1
        flipView.setUp(imageSet)
        flipView.startAnimation()
        flipView.backgroundColor = UIColor.clear
        flipContainer.backgroundColor = UIColor.clear
        
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
