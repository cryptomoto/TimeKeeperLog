//
//  WelcomeViewController.swift
//  Keeper
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var pageIndex: Int = 0
    
    var tutorialPageViewController: WelcomePageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.redColor()
        pageControl.addTarget(self, action: #selector(WelcomeViewController.didChangePageControlValue), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? WelcomePageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @objc func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
        
        
    }
}

extension WelcomeViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: WelcomePageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: WelcomePageViewController,
                                    didUpdatePageIndex index: Int) {
        
        pageControl.currentPage = index
        
        if pageControl.currentPage == 3 {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.pageControl.alpha = 0.0
                
                }, completion: nil)
            //pageControl.hidden = true
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.pageControl.alpha = 1.0
                
                }, completion: nil)
            //pageControl.hidden = false
        }
        
    }

}
