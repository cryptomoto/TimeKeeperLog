//
//  WelcomePageViewController.swift
//  Keeper
//
//  Created by admin on 4/28/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController {

    weak var tutorialDelegate: TutorialPageViewControllerDelegate?
    
    var arrPageTitle: NSArray = NSArray()
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.newColoredViewController("First"),
                self.newColoredViewController("Second"),
                self.newColoredViewController("Third")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        
        //   arrPageTitle = [firstString, secondString, thirdString, fourthString]
        
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        
        tutorialDelegate?.tutorialPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
    }
    
    func getViewControllerAtIndex(_ index: NSInteger) -> WelcomeViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageContent") as! WelcomeViewController
        
        // pageContentViewController.textHere.text = "\(arrPageTitle[index])"
        //  pageContentViewController.strPhotoName = "1.jpg"
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        print("TUTORIALPAGE SCROLL TO VIEW")
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
            
            
        }
    }
    
    fileprivate func newColoredViewController(_ color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)ViewController")
    }
    
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        print("TUTORIALPAGE SCROLL TO VIEWCONTROLLER")
        setViewControllers([viewController], direction: direction, animated: true, completion: { (finished) -> Void in
            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    fileprivate func notifyTutorialDelegateOfNewIndex() {
        print("TUTORIALPAGE NOTIFY TUTORIAL")
        
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
            tutorialDelegate?.tutorialPageViewController(self, didUpdatePageIndex: index)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension WelcomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        notifyTutorialDelegateOfNewIndex()
    }
    
}

protocol TutorialPageViewControllerDelegate: class {
    
    func tutorialPageViewController(_ tutorialPageViewController: WelcomePageViewController,
                                    didUpdatePageCount count: Int)
    
    func tutorialPageViewController(_ tutorialPageViewController: WelcomePageViewController,
                                    didUpdatePageIndex index: Int)
    
    
    
}
