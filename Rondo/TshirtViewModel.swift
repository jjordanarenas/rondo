//
//  TshirtViewModel.swift
//  Rondo
//
//  Created by Jorge Jordán on 02/12/15.
//  Copyright © 2015 Insane Platypus Games. All rights reserved.
//

import Foundation
import UIKit

class TshirtViewModel: NSObject {
    
    var title: String = ""
    //var arrayButtons = [UIButton]()
    //var subtitle: String = ""
    //var nextButtonText: String = ""
    //var videoName: String = ""
    //var screenShot: String = ""
    var fileName = ""
    var arrayTshirts = [String]()

    override init() {
        super.init()
    }
    
    func retrieveTshirtsFromFile(file: String) -> [AnyObject] {
        fileName = file
        var tshirtsDictionary: NSDictionary!
        
        // Get level dictionary root
        if let pathToFile = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            tshirtsDictionary = NSDictionary(contentsOfFile: pathToFile)
            
            arrayTshirts = tshirtsDictionary.allValues as! [String]
            print(arrayTshirts.count)
        }
        return arrayTshirts
    }
}