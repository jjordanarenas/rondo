//
//  MenuViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 10/12/15.
//  Copyright © 2015 Insane Platypus Games. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    //var pageViewController: UIPageViewController!
    
  @IBOutlet weak var backButton: UIButton!
  
  @IBAction func closeMenu(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initializeTshirtsMenu()
    }
    
    
    func initializeTshirtsMenu() {
       // pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TshirtViewController") as! UIPageViewController
        //pageViewController.dataSource = self
      //  pageViewController.dataSource = TshirtViewController
       // pageViewController.delegate = TshirtViewController
    
        //self.addChildViewController(pageViewController)
        //self.view.insertSubview(pageViewController.view, atIndex: 1)
        
        //pageViewController.didMoveToParentViewController(self)
    }
    
    @IBOutlet weak var buttonTshirts: UIButton!
    
    @IBAction func showTshirtsMenu(sender: AnyObject) {
        let mainView = UIStoryboard(name: "Tshirts", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewControllerWithIdentifier("MenuTshirtsViewController") as UIViewController
        self.presentViewController(viewcontroller, animated: true, completion: nil)
       // self.view.window!.rootViewController.pushViewController(viewcontroller, animated: true)
        
        //self.addChildViewController(viewcontroller)
       //self.didMoveToParentViewController(viewcontroller)
        //self.view.window!.rootViewController = viewcontroller
    }
}