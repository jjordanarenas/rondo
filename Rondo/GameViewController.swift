//
//  GameViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 02/09/15.
//  Copyright (c) 2015 Insane Platypus Games. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  //  var interstitial: GADInterstitial?
   // private var k_interstitial_id = "ca-app-pub-5767684210972160/3749421535"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = MainMenuScene(size: view.bounds.size)

        // Linking view controller and scene to show ads
        scene.viewController = self
        
        // Configure the view.
        let skView = self.view as! SKView
      
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
    /////    self.preloadInterstitial()
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Portrait
        } else {
            return .Portrait
        }
    }

    /*
    func preloadInterstitial() {
        interstitial = GADInterstitial(adUnitID: k_interstitial_id)
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        interstitial!.loadRequest(request)
        
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
