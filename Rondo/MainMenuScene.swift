//
//  MainMenu.swift
//  Rondo
//
//  Created by Jorge Jordán on 17/05/16.
//  Copyright © 2016 Insane Platypus Games. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
  var viewController: GameViewController!
  var background: SKSpriteNode!
  var labelInitGame: SKLabelNode!
  
  override func didMoveToView(view: SKView) {
    initializeMenu()
  }
  
  func initializeMenu() {
    let background = SKSpriteNode(color: UIColor.orangeColor(), size: view!.frame.size)
    background.position = CGPoint(x: CGRectGetMidX(view!.frame), y: CGRectGetMidY(view!.frame))
    addChild(background)
    //initializeBackground()
    initializeButtons()
    

  }
  
  func initializeBackground() {
    background = SKSpriteNode(imageNamed: "background_init")
    background.zPosition = -1
    background.position = CGPoint(x:(view!.bounds.size.width/2), y: view!.bounds.size.height/2)
    
    // Add the background
    addChild(background)
  }
  
  func initializeButtons() {
    // Initialize the label with a font name
    labelInitGame = SKLabelNode(fontNamed:"Arial Bold")
    // Set color, size and position
    labelInitGame.fontColor = UIColor(red: 0.0, green: 0.129, blue: 0.486, alpha: 1.0)
    labelInitGame.fontSize = 60
    labelInitGame.position = CGPoint(x:view!.bounds.size.width/2, y:view!.bounds.size.height/2)
    // Set text
    labelInitGame.text = "Survival"
    // Set node's name
    labelInitGame.name = "init_game_label"
    
    // Add the label to the scene
    addChild(labelInitGame)

  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      
      let location = touch.locationInNode(self)
      
      // Check if label touched
      if  self.nodeAtPoint(location).name == "init_game_label" {
        self.initGame()
      }
    }
  }
  
  func initGame() {
    // Create scene transition
    let sceneTransition = SKTransition.doorsOpenVerticalWithDuration(1.25)
    // Create next scene
    let gameScene = GameScene(size: view!.bounds.size)
    // Linking view controller and scene to show ads
    gameScene.viewController = viewController
    // Present next scene with transition
    view?.presentScene(gameScene, transition: sceneTransition)
  }
}
