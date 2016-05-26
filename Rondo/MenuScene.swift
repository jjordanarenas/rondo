//
//  MenuScene.swift
//  Rondo
//
//  Created by Jorge Jordán on 24/05/16.
//  Copyright © 2016 Insane Platypus Games. All rights reserved.
//

import SpriteKit
import UIKit

class MenuScene: SKScene {
  override func didMoveToView(view: SKView) {
    initializeMenu()
  }
  
  func initializeMenu() {
    view?.backgroundColor = UIColor.clearColor()
    view!.frame.size = CGSize(width: 100, height: 100)
    let background = SKSpriteNode(color: UIColor.orangeColor(), size: view!.frame.size)
    background.position = CGPoint(x: CGRectGetMidX(view!.frame), y: CGRectGetMidY(view!.frame))
    addChild(background)
  }
}