//
//  ChooseTshirtViewController.swift
//  Rondo
//
//  Created by Jorge Jordán on 21/04/16.
//  Copyright © 2016 Insane Platypus Games. All rights reserved.
//

import Foundation
import UIKit

class ChooseTshirtViewController: UIViewController, UIScrollViewDelegate {

  var ownedTshirtsScrollView: UIScrollView!
  var containerView = UIView!()
  
  var viewWidth: CGFloat = 0.0
  var viewHeight: CGFloat = 0.0
  var horizontalGap: CGFloat = 0.0
  var verticalGap: CGFloat = 0.0
  
  var gapBetweenRows: CGFloat = 0.0
  var gapBetweenColumns: CGFloat = 0.0
  
  var buttonWidth: CGFloat = 0.0
  var buttonHeight: CGFloat = 0.0
  
  var numOwnedTshirts = 0
  
  var k_NUM_COLUMNS: Int = 4
  //var k_NUM_ROWS: Int = 7
  var numRows: Int = 0
   var arrayOwnedTshirts = [String]()
  
  
  @IBOutlet weak var buttonTshirt: UIButton!
  //var fileOwnedTshirts = "OwnedTshirts.plist"
  var fileOwnedTshirts = "OwnedTshirts"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ownedTshirtsScrollView = UIScrollView()
    ownedTshirtsScrollView.delegate = self
    ownedTshirtsScrollView.contentSize = CGSizeMake(1000, 1000)
    
    containerView = UIView()
    
    initializeAuxVariables()
    initializeTShirtsView()
    
    ownedTshirtsScrollView.addSubview(containerView)
    
    /////////view.addSubview(ownedTshirtsScrollView)
 
  }
 
  @IBAction func click(sender: AnyObject) {
    performSegueWithIdentifier("PlayGame", sender: sender)
  }
  
  @IBAction func buttonClick(sender: AnyObject) {
    performSegueWithIdentifier("PlayGame", sender: sender)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PlayGame" {
      let chooseTshirtViewController = segue.destinationViewController as! GameViewController
      
    }
  }
  
  func loadOwnedTshirts() {
    let path = dataFilePath()
    
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      
      if let data = NSData(contentsOfFile: path) {
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        arrayOwnedTshirts = unarchiver.decodeObjectForKey(fileOwnedTshirts) as! [String]
        
        unarchiver.finishDecoding() }
      
    }
    
   arrayOwnedTshirts.append("valenciafc")
    arrayOwnedTshirts.append("fcbarcelona")
    arrayOwnedTshirts.append("realmadrid")
    
    
    numOwnedTshirts = arrayOwnedTshirts.count
    
  }


  
  func initializeAuxVariables() {
    var auxButton: UIButton!
    
    auxButton = UIButton()
    auxButton.setImage(UIImage(contentsOfFile: "fcbarcelona_main"), forState: UIControlState.Normal)
    
    viewWidth = view!.bounds.size.width
    viewHeight = view!.bounds.size.height
    
    
    numRows = numOwnedTshirts / k_NUM_COLUMNS
    
    if numRows == 0 {
      numRows = 1
    }
    
    horizontalGap = viewWidth - (CGFloat(k_NUM_COLUMNS + 3) * auxButton.frame.width)
    verticalGap = viewHeight - (CGFloat(numRows + 3) * auxButton.frame.height)
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
    
    for row in 0..<numRows {
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
        //print("POSITION X: \(xPosition)\nPOSITION Y: \(yPosition)")
        print("row: \(row)\ncolumn: \(column)")
        
        button = UIButton(type:UIButtonType.System) // as UIButton
        button.setImage(UIImage(named: "fcbarcelona_main"), forState: UIControlState.Normal)
        button.frame = CGRectMake(10, 50, 50, 50)
        
        ////////button.addTarget(self, action: "chooseTshirt:", forControlEvents: UIControlEvents.TouchUpInside)
        
     //   containerView.addSubview(button)
        
        
      }
    }
    
    
  }
  
  func chooseTshirt(sender:UIButton) {
    print(sender)
    
   ////// let vc = GameViewController()
    
  //////  presentViewController(vc, animated: true, completion: nil)
  }
  
  
  @IBOutlet weak var backButton: UIButton!
  
  @IBAction func closeMenu(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
  }

  func dataFilePath() -> String {
      return "\(documentsDirectory())/\(fileOwnedTshirts).plist"
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    ownedTshirtsScrollView.frame = view.bounds
    containerView.frame = CGRectMake(0, 0, ownedTshirtsScrollView.contentSize.width, ownedTshirtsScrollView.contentSize.height)
  }

  
      
      
      
  
  
  



/*func saveChecklistItems() {
  let data = NSMutableData()
  let archiver = NSKeyedArchiver(forWritingWithMutableData: data) archiver.encodeObject(items, forKey: "ChecklistItems") archiver.finishEncoding()
  data.writeToFile(dataFilePath(), atomically: true)
  }
  */

  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
