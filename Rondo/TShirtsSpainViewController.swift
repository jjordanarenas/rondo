//
//  TShirtsSpainViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 19/09/15.
//  Copyright © 2015 Insane Platypus Games. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TShirtsSpainViewController: UIViewController, UIScrollViewDelegate {
    
    var k_NUM_COLUMNS: Int = 4
    var k_NUM_ROWS: Int = 7
    var k_FCBARCELONA_MAIN = "fcbarcelona_main"
    var k_FCBARCELONA_SECOND = "fcbarcelona_second"
    var k_FCBARCELONA_THIRD = "fcbarcelona_third"
    
    //var scrollView: UIScrollView!
    var scrollView: UIScrollView!
    var containerView = UIView!()
    
    var buttonWidth: CGFloat = 0.0
    var buttonHeight: CGFloat = 0.0
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var horizontalGap: CGFloat = 0.0
    var verticalGap: CGFloat = 0.0
    
    var gapBetweenRows: CGFloat = 0.0
    var gapBetweenColumns: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      initializeSwipeGestures()
      
      
      
      
      
/*
        let buttonOne = UIButton(type:UIButtonType.System) // as UIButton
    //    button.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)
        buttonOne.setImage(UIImage(named: "fcbarcelona_main"), forState: UIControlState.Normal)
        buttonOne.frame = CGRectMake(10, 50, 50, 50)
        /////buttonOne.backgroundColor = UIColor.greenColor()
        buttonOne.setTitle("test", forState: UIControlState.Normal)
        
        buttonOne.addTarget(self, action: "buttonAction1x1:", forControlEvents: UIControlEvents.TouchUpInside)*/
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(1000, 1000)
        
        containerView = UIView()
        
        
        
        
        initializeAuxVariables()
        initializeTShirtsView()
        
        
        
        ////////containerView.addSubview(buttonOne)

        scrollView.addSubview(containerView)

        view.addSubview(scrollView)
        
        
        
        
        
        //self.view.addSubview(buttonOne)
    ///////////    containerView.addSubview(buttonOne)
        
        /*
        //scrollView = UIScrollView()
        //scrollView.delegate = self
        //self.scrollView.contentSize = CGSizeMake(1000, 1000)
        
        //scrollView = UIScrollView(frame: self.view.bounds)
        scrollView = UIScrollView(frame: CGRectMake(0,0,320,480))
        
        scrollView.delegate = self
        
        scrollView.showsVerticalScrollIndicator=true
        scrollView.scrollEnabled=true
        scrollView.userInteractionEnabled=true
        
        containerView = UIView()
        
        
        scrollView.addSubview(containerView)
        scrollView.contentSize = CGSizeMake(320,960)
        self.view.addSubview(scrollView)
        
        
        
        
        
        
        //containerView = UIView()
        //scrollView.addSubview(containerView)
       // view.addSubview(scrollView)
        
        
        
        self.initializeAuxVariables()
        self.initializeTShirtsView()*/
    }

  func initializeSwipeGestures() {
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    
    leftSwipe.direction = .Left
    rightSwipe.direction = .Right
    
    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(rightSwipe)
  
  }
  
  func handleSwipes(sender:UISwipeGestureRecognizer) {
    if (sender.direction == .Left) {
      print("Swipe Left")
    }
    
    if (sender.direction == .Right) {
      print("Swipe Right")
    }
  }
  
    func initializeAuxVariables() {
        var auxButton: UIButton!
        
        auxButton = UIButton()//imageNamed: "fcbarcelona_main")
        auxButton.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)
///        auxButton.frame.size.width = 50
                ///auxButton.frame.size.height = 50
        //auxButton.frame = CGRectMake(10, 50, 50, 50)
        viewWidth = view!.bounds.size.width
        viewHeight = view!.bounds.size.height
        
        horizontalGap = viewWidth - (CGFloat(k_NUM_COLUMNS + 3) * auxButton.frame.width)
        verticalGap = viewHeight - (CGFloat(k_NUM_ROWS + 3) * auxButton.frame.height)
            //viewWidth - (CGFloat(k_NUM_ROWS + 3) * auxButton.frame.height)
        
        buttonWidth = auxButton.frame.width
        buttonHeight = auxButton.frame.height
        
        print("horizontalGap: \(horizontalGap)\nverticalGap: \(verticalGap)")
    }
    
    func initializeTShirtsView() {
//        var xPosition: CGFloat = 0.0
                var xPosition: CGFloat = 0.0//scrollView.frame.origin.x
//        var yPosition: CGFloat = 0.0
        var yPosition: CGFloat = 0.0//scrollView.frame.origin.y
        
        var button: UIButton!
            
        for row in 0..<k_NUM_ROWS {
            if row == 0 {
                yPosition += 2 * verticalGap
            } else {
                yPosition += verticalGap
            }

            for column in 0..<k_NUM_COLUMNS {
                if column == 0 {
                    xPosition += 2 * horizontalGap
                } else {
                    xPosition += horizontalGap
                }
                print("POSITION X: \(xPosition)\nPOSITION Y: \(yPosition)")
                
                button = UIButton(type:UIButtonType.System) // as UIButton
                //    button.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)
                button.setImage(UIImage(named: "fcbarcelona_main"), forState: UIControlState.Normal)
                button.frame = CGRectMake(10, 50, 50, 50)
                /////buttonOne.backgroundColor = UIColor.greenColor()
                button.setTitle("test", forState: UIControlState.Normal)
                
                button.addTarget(self, action: "buttonAction1x1:", forControlEvents: UIControlEvents.TouchUpInside)

                
                
                containerView.addSubview(button)

                
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

