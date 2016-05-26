//
//  GameScene.swift
//  Rondo
//
//  Created by Jorge Jordán on 02/09/15.
//  Copyright (c) 2015 Insane Platypus Games. All rights reserved.
//

import SpriteKit
import StoreKit
import Darwin
import UIKit
import GoogleMobileAds

enum CPUTeam : Int {
    case CPU_JAPAN = 0
    case CPU_CHINA = 1
    case CPU_NIGERIA = 2
    case CPU_BRAZIL = 3
    case CPU_GERMANY = 4
    case CPU_SPAIN = 5
    
    init(value: Int) {
        switch value {
        case 0:
            self = .CPU_JAPAN
        case 1:
            self = .CPU_CHINA
        case 2:
            self = .CPU_NIGERIA
        case 3:
            self = .CPU_BRAZIL
        case 4:
            self = .CPU_GERMANY
        case 5:
            self = .CPU_SPAIN
        default:
            self = .CPU_JAPAN
        }
    }
}

class GameScene: SKScene, SKProductsRequestDelegate, GADInterstitialDelegate {
    var interstitial: GADInterstitial?
    var viewController: GameViewController!
    
    private var k_ball_name = "ball"
    private var k_nonPlayableCharacter1_name = "nonPlayableCharacter1"
    private var k_nonPlayableCharacter2_name = "nonPlayableCharacter2"
    private var k_bestNumberOfPasses = "bestNumberOfPasses"
    private var k_user_default_no_ads = "user_default_no_ads"
    private var k_user_default_passes_to_next_tshirt = "user_default_passes_to_next_tshirt"
    
    private var k_interstitial_id = "ca-app-pub-5767684210972160/3749421535"
    private var testingTeam = CPUTeam.CPU_SPAIN
    
    private var k_NUM_TEAMS: Int = 6
    private var k_MAX_RANDOM_VALUE: Int = 5
  private var k_INITIAL_NEXT_TSHIRT_VALUE: Int = 100
    
    private var k_IPHONE6_WIDTH: CGFloat = 375
    private var k_IPHONE6PLUS_WIDTH: CGFloat = 414
    private var k_IPAD_WIDTH: CGFloat = 768
    private var k_IPADAIR_WIDTH: CGFloat = 768
    
    private var K_JAPAN_SPEED_IPHONE: Double = 0.0
    private var K_CHINA_SPEED_IPHONE: Double = 0.0
    private var K_NIGERIA_SPEED_IPHONE: Double = 0.0
    private var K_GERMANY_SPEED_IPHONE: Double = 0.0
    private var K_SPAIN_SPEED_IPHONE: Double = 0.0
    private var K_BRAZIL_SPEED_IPHONE: Double = 0.0
    
    private var K_JAPAN_SPEED_IPAD: Double = 0.0
    private var K_CHINA_SPEED_IPAD: Double = 0.0
    private var K_NIGERIA_SPEED_IPAD: Double = 0.0
    private var K_GERMANY_SPEED_IPAD: Double = 0.0
    private var K_SPAIN_SPEED_IPAD: Double = 0.0
    private var K_BRAZIL_SPEED_IPAD: Double = 0.0
    
    private var K_RANDOM_VALUE_FOR_ADS: Int = 3
    
    private var numOfPlayableCharacters = 5
    private var playableCharactersDistance:CGFloat = 0.0
    private var nonPlayableCharactersDistance:CGFloat = 0.0
    private var ballDistance:CGFloat = 0.0
    private var ballSpeed: Double = 0.0

    private var nonPlayableSpeed: Double = 0.0
    
    private var initialPosition1: CGPoint!
    private var initialPosition2: CGPoint!
    private var initialPosition3: CGPoint!
    private var initialPosition4: CGPoint!
    private var initialPosition5: CGPoint!
    
    private var initialPositionCPU1: CGPoint!
    private var initialPositionCPU2: CGPoint!
    
    private var initialBallPosition1: CGPoint!
    private var initialBallPosition2: CGPoint!
    private var initialBallPosition3: CGPoint!
    private var initialBallPosition4: CGPoint!
    private var initialBallPosition5: CGPoint!
    
    private var playableCharacter1: SKSpriteNode!
    private var playableCharacter2: SKSpriteNode!
    private var playableCharacter3: SKSpriteNode!
    private var playableCharacter4: SKSpriteNode!
    private var playableCharacter5: SKSpriteNode!
    
    private var nonPlayableCharacter1: SKSpriteNode!
    private var nonPlayableCharacter2: SKSpriteNode!
    
    private var ball: SKSpriteNode!
    
    private var isGameStarted: Bool = false
    private var isGameOver:Bool = true
    private var isTouchable:Bool = true
    private var isAdsDisabled: Bool = false
    
    private var isPlayer1Position: Bool = true
    private var isPlayer2Position: Bool = false
    private var isPlayer3Position: Bool = false
    private var isPlayer4Position: Bool = false
    private var isPlayer5Position: Bool = false
  
  private var menuScene: MenuScene!
  private var menuButton: SKSpriteNode!
  
    var restartButton: SKNode! = nil

    //let ballCategory: UInt32 = 0x1 << 0
    //let nonPlayableCharacterCategory1: UInt32 = 0x1 << 1
    //let nonPlayableCharacterCategory2: UInt32 = 0x1 << 2

    var chooseTshirtViewController: ChooseTshirtViewController!
  
    private var bestNumberOfPasses: SKLabelNode!
    private var currentNumberOfPasses: SKLabelNode!
  private var passesToNextTshirtLabel: SKLabelNode!
    
    private var numberOfPasses: Int = 0
    private var numberOfPassesInARow: Int = 0
    private var lastNumberOfPasses: Int = 0
  private var passesToNextTshirt: Int = 0
    
    private var currentTeam: Int = 0
    
    
    private var numOfGameWithAds: Int = 0
    private var currentNumOfGame: Int = 0

    private var buyButton:UIButton!
    
    private var defaults: NSUserDefaults!
  
  private var menu: SKSpriteNode!
  
    override func didMoveToView(view: SKView) {
//      if is the first time
     /* chooseTshirtViewController = ChooseTshirtViewController()
      view.addSubview(chooseTshirtViewController.view)
      */
      scene?.paused = false
      
        initializeGame()
        preloadInterstitial()
      initializeMenuButton()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var ballMovement: SKAction!
        var duration: Double = 0.0
        //ccpDistance(nextPosition, _yeti.position) /
        //speed;
        
        
        if !ball.hasActions() {
        for touch in touches {
            let location = touch.locationInNode(self)
          
          if scene!.paused {
            hideMenu()
          }
          if nodeAtPoint(location).name == "showMenu" {
            showMenu()
           break
          }
                if ball.hasActions() {
                   print("HAS ACTIONS")
                }
            // Check if the location of the touch is within the button's bounds
            if restartButton.containsPoint(location) {
                self.numberOfPasses = 0
                self.updateNumberOfPassesLabel()
                self.initializeGame()
                restartButton.hidden = true
            } else if (CGRectContainsPoint(playableCharacter1.frame, location) && isTouchable) {
                duration = Double(self.distanceBetween(point: ball.position, andPoint: initialBallPosition1)) / ballSpeed
                ballMovement = SKAction.moveTo(initialBallPosition1, duration: duration)
                
                let checkPassHappened = SKAction.runBlock {
                    if self.distanceBetween(point: self.ball.position, andPoint: self.initialBallPosition1) < self.ball.size.width / 2 {
                        self.numberOfPasses++
                        self.numberOfPassesInARow++
                      if self.passesToNextTshirt > 0 {
                        self.passesToNextTshirt--
                      }
                        self.updateNumberOfPassesLabel()
                      self.updateBestNumberOfPassesLabel()
                      self.updateNextTshirtInLabel()
                    }
                }
                
                ball.runAction(SKAction.sequence([ballMovement, checkPassHappened]))
                //ball.runAction(ballMovement)
                
                if !isGameStarted {
                    isGameStarted = true
                }
                
                if isGameOver {
                    isGameOver = false
                }
                
                isPlayer1Position = true
                isPlayer2Position = false
                isPlayer3Position = false
                isPlayer4Position = false
                isPlayer5Position = false
                
            } else if (CGRectContainsPoint(playableCharacter2.frame, location) && isTouchable) {
                duration = Double(self.distanceBetween(point: ball.position, andPoint: initialBallPosition2)) / ballSpeed
                ballMovement = SKAction.moveTo(initialBallPosition2, duration: duration)
                let checkPassHappened = SKAction.runBlock {
                    //if self.ball.position == self.initialBallPosition2 {
                    if self.distanceBetween(point: self.ball.position, andPoint: self.initialBallPosition2) < self.ball.size.width / 2 {
                    self.numberOfPasses++
                      self.numberOfPassesInARow++
                      if self.passesToNextTshirt > 0 {
                        self.passesToNextTshirt--
                      }
                        self.updateNumberOfPassesLabel()
                      self.updateBestNumberOfPassesLabel()
                      self.updateNextTshirtInLabel()
                    }
                }
                
                ball.runAction(SKAction.sequence([ballMovement, checkPassHappened]))
                //ball.runAction(ballMovement)

                
                if !isGameStarted {
                    isGameStarted = true
                }
                if isGameOver {
                    isGameOver = false
                }
                
                isPlayer1Position = false
                isPlayer2Position = true
                isPlayer3Position = false
                isPlayer4Position = false
                isPlayer5Position = false
                
            } else if (CGRectContainsPoint(playableCharacter3.frame, location) && isTouchable) {
                duration = Double(self.distanceBetween(point: ball.position, andPoint: initialBallPosition3)) / ballSpeed
                ballMovement = SKAction.moveTo(initialBallPosition3, duration: duration)
                let checkPassHappened = SKAction.runBlock {
                    //if self.ball.position == self.initialBallPosition3 {
                    if self.distanceBetween(point: self.ball.position, andPoint: self.initialBallPosition3) < self.ball.size.width / 2 {
                    self.numberOfPasses++
                      self.numberOfPassesInARow++
                      if self.passesToNextTshirt > 0 {
                        self.passesToNextTshirt--
                      }
                        self.updateNumberOfPassesLabel()
                      self.updateBestNumberOfPassesLabel()
                      self.updateNextTshirtInLabel()
                    }
                }
                
                ball.runAction(SKAction.sequence([ballMovement, checkPassHappened]))
                //ball.runAction(ballMovement)

                if !isGameStarted {
                    isGameStarted = true
                }
                if isGameOver {
                    isGameOver = false
                }
                
                isPlayer1Position = false
                isPlayer2Position = false
                isPlayer3Position = true
                isPlayer4Position = false
                isPlayer5Position = false
                
            } else if (CGRectContainsPoint(playableCharacter4.frame, location) && isTouchable) {
                duration = Double(self.distanceBetween(point: ball.position, andPoint: initialBallPosition4)) / ballSpeed
                ballMovement = SKAction.moveTo(initialBallPosition4, duration: duration)
                let checkPassHappened = SKAction.runBlock {
                    //if self.ball.position == self.initialBallPosition4 {
                    if self.distanceBetween(point: self.ball.position, andPoint: self.initialBallPosition4) < self.ball.size.width / 2 {
                    self.numberOfPasses++
                      self.numberOfPassesInARow++
                      if self.passesToNextTshirt > 0 {
                        self.passesToNextTshirt--
                      }
                        self.updateNumberOfPassesLabel()
                      self.updateBestNumberOfPassesLabel()
                      self.updateNextTshirtInLabel()
                    }
                }
                
                ball.runAction(SKAction.sequence([ballMovement, checkPassHappened]))
                //ball.runAction(ballMovement)

                if !isGameStarted {
                    isGameStarted = true
                }
                if isGameOver {
                    isGameOver = false
                }
                isPlayer1Position = false
                isPlayer2Position = false
                isPlayer3Position = false
                isPlayer4Position = true
                isPlayer5Position = false
                
            } else if (CGRectContainsPoint(playableCharacter5.frame, location) && isTouchable) {
                duration = Double(self.distanceBetween(point: ball.position, andPoint: initialBallPosition5)) / ballSpeed
                ballMovement = SKAction.moveTo(initialBallPosition5, duration: duration)
                let checkPassHappened = SKAction.runBlock {
                    //if self.ball.position == self.initialBallPosition5 {
                    if self.distanceBetween(point: self.ball.position, andPoint: self.initialBallPosition5) < self.ball.size.width / 2 {
                    self.numberOfPasses++
                      self.numberOfPassesInARow++
                      if self.passesToNextTshirt > 0 {
                        self.passesToNextTshirt--
                      }
                        self.updateNumberOfPassesLabel()
                      self.updateBestNumberOfPassesLabel()
                      self.updateNextTshirtInLabel()
                    }
                }
                
                ball.runAction(SKAction.sequence([ballMovement, checkPassHappened]))
                //ball.runAction(ballMovement)

                if !isGameStarted {
                    isGameStarted = true
                }
                if isGameOver {
                    isGameOver = false
                }
                isPlayer1Position = false
                isPlayer2Position = false
                isPlayer3Position = false
                isPlayer4Position = false
                isPlayer5Position = true
                
            }
            //break
        }
        }
    }
   
    func initializeDistances() {
    
    
    
    
    
        let auxPlayerSprite = SKSpriteNode(imageNamed:"red")
        let auxBallSprite = SKSpriteNode(imageNamed:"red")
        playableCharactersDistance = (view!.bounds.size.width / 2) - (auxPlayerSprite.frame.width / 2)
        nonPlayableCharactersDistance = (auxPlayerSprite.frame.width / 2)
        ballDistance = playableCharactersDistance - (auxBallSprite.frame.width / 2)
    }
    
    func initializePlayableCharacters() {
        switch numOfPlayableCharacters {
        case 5:
            self.initializeInPentagonShape()
            //setball???
        default:
            print("default")
        }
    }
    
    func initializeBall() {
        if ball == nil  || ball.parent == nil {
            ball = SKSpriteNode(imageNamed:"ball")
        
        
        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0
        var angle: CGFloat = 0.0
        
        for i in 0...4 {
            angle = CGFloat(Double(i) * 2 * M_PI) / 5
            positionX = (view!.bounds.size.width / 2) + CGFloat(cos((angle) + 180)) * ballDistance
            positionY = (view!.bounds.size.height / 2) + CGFloat(sin((angle) + 180)) * ballDistance
            switch i {
            case 0:
                initialBallPosition1 = CGPointMake(positionX, positionY)
            case 1:
                initialBallPosition2 = CGPointMake(positionX, positionY)
            case 2:
                initialBallPosition3 = CGPointMake(positionX, positionY)
            case 3:
                initialBallPosition4 = CGPointMake(positionX, positionY)
            case 4:
                initialBallPosition5 = CGPointMake(positionX, positionY)
            default:
                print("default")
            }
        }
        
        
 /*       let physicsBody = SKPhysicsBody(rectangleOfSize: ball.frame.size)
        /////physicsBody.dynamic = true
        //    physicsBody.dynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = ballCategory
        
        physicsBody.usesPreciseCollisionDetection = true
//            physicsBody.collisionBitMask = ballCategory
            physicsBody.collisionBitMask = nonPlayableCharacterCategory1 | nonPlayableCharacterCategory2
        physicsBody.contactTestBitMask = nonPlayableCharacterCategory1 | nonPlayableCharacterCategory2
        
        */
      /////////////  ball.physicsBody = physicsBody
        ball.name = k_ball_name
        
        
        
        self.addChild(ball)
        }
        
        ball.position = initialBallPosition1
    }
    
    func initializeNonPlayableCharacters() {
        switch numOfPlayableCharacters {
        case 5:
            self.initializeCPUPlayers(2)
            //setball???
        default:
            print("default")
        }
    }
    
    func initializeInPentagonShape() {
        
        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0
        var angle: CGFloat = 0.0
        
        for i in 0...4 {
            angle = CGFloat(Double(i) * 2 * M_PI) / 5
            positionX = (view!.bounds.size.width / 2) + CGFloat(cos((angle) + 180)) * playableCharactersDistance
            positionY = (view!.bounds.size.height / 2) + CGFloat(sin((angle) + 180)) * playableCharactersDistance
            switch i {
                case 0:
                    initialPosition1 = CGPointMake(positionX, positionY)
                    playableCharacter1 = SKSpriteNode(imageNamed:"red")
                    playableCharacter1.position = initialPosition1
                    self.addChild(playableCharacter1)
                case 1:
                    initialPosition2 = CGPointMake(positionX, positionY)
                    playableCharacter2 = SKSpriteNode(imageNamed:"red")
                    playableCharacter2.position = initialPosition2
                    self.addChild(playableCharacter2)
                case 2:
                    initialPosition3 = CGPointMake(positionX, positionY)
                    playableCharacter3 = SKSpriteNode(imageNamed:"red")
                    playableCharacter3.position = initialPosition3
                    self.addChild(playableCharacter3)
                case 3:
                    initialPosition4 = CGPointMake(positionX, positionY)
                    playableCharacter4 = SKSpriteNode(imageNamed:"red")
                    playableCharacter4.position = initialPosition4
                    self.addChild(playableCharacter4)
                case 4:
                    initialPosition5 = CGPointMake(positionX, positionY)
                    playableCharacter5 = SKSpriteNode(imageNamed:"red")
                    playableCharacter5.position = initialPosition5
                    self.addChild(playableCharacter5)
                default:
                    print("default")
            }
        }
    }
    
    func initializeCPUPlayers(numOfPlayers: Int) {
        var positionCPU1X: CGFloat = 0.0
        var positionCPU2X: CGFloat = 0.0
        let positionY: CGFloat = (view!.bounds.size.height / 2)
        
        switch numOfPlayers {
            case 2:
                positionCPU1X = (view!.bounds.size.width / 2) + nonPlayableCharactersDistance
                positionCPU2X = (view!.bounds.size.width / 2) - nonPlayableCharactersDistance
                initialPositionCPU1 = CGPointMake(positionCPU1X, positionY)
                initialPositionCPU2 = CGPointMake(positionCPU2X, positionY)
            
            if nonPlayableCharacter1 == nil || nonPlayableCharacter1.parent == nil {
                nonPlayableCharacter1 = SKSpriteNode(imageNamed:"blue")
            
            
   /*
                let physicsBody1 = SKPhysicsBody(rectangleOfSize: nonPlayableCharacter1.frame.size)
                ////physicsBody1.dynamic = true
                //physicsBody1.dynamic = false
                physicsBody1.affectedByGravity = false
                physicsBody1.allowsRotation = false
                physicsBody1.categoryBitMask = nonPlayableCharacterCategory1
                
                physicsBody1.usesPreciseCollisionDetection = true
//                physicsBody1.collisionBitMask = nonPlayableCharacterCategory1
                physicsBody1.collisionBitMask = ballCategory
                physicsBody1.contactTestBitMask = ballCategory
            
       /////////////         nonPlayableCharacter1.physicsBody = physicsBody1*/
                nonPlayableCharacter1.name = k_nonPlayableCharacter1_name
            
                self.addChild(nonPlayableCharacter1)
            }
            
            nonPlayableCharacter1.position = initialPositionCPU1
            
            
            
            if nonPlayableCharacter2 == nil || nonPlayableCharacter2.parent == nil {
                nonPlayableCharacter2 = SKSpriteNode(imageNamed:"blue")
            
            
            /*    let physicsBody2 = SKPhysicsBody(rectangleOfSize: nonPlayableCharacter2.frame.size)
                ////physicsBody2.dynamic = true
                //physicsBody2.dynamic = false
                physicsBody2.affectedByGravity = false
                physicsBody2.allowsRotation = false
                physicsBody2.categoryBitMask = nonPlayableCharacterCategory2
                
                physicsBody2.usesPreciseCollisionDetection = true
                //physicsBody2.collisionBitMask = nonPlayableCharacterCategory2
                physicsBody2.collisionBitMask = ballCategory
                physicsBody2.contactTestBitMask = ballCategory
            
           /////////////            nonPlayableCharacter2.physicsBody = physicsBody2*/
                nonPlayableCharacter2.name = k_nonPlayableCharacter2_name
            
                self.addChild(nonPlayableCharacter2)
            }
                nonPlayableCharacter2.position = initialPositionCPU2
            
            
            default:
                print("default")
        }
    }
    
    func distanceBetween(point p1:CGPoint, andPoint p2:CGPoint) -> CGFloat {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    func takeDefensiveDecision(player: SKSpriteNode) {
        let duration = Double(self.distanceBetween(point: ball.position, andPoint: player.position)) / nonPlayableSpeed
        
        player.runAction(SKAction.moveTo(ball.position, duration: duration))
        
    }
    
    func takePasiveDecision(player: SKSpriteNode) {
        var duration: Double
        if isPlayer1Position {
            
            if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter2.position) < self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter5.position)) {
                duration = Double(self.distanceBetween(point: playableCharacter5.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))

            } else {
                duration = Double(self.distanceBetween(point: playableCharacter2.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
            }
        } else if isPlayer2Position {
            
            if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter3.position) < self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter1.position)) {
                duration = Double(self.distanceBetween(point: playableCharacter1.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                
            } else {
                duration = Double(self.distanceBetween(point: playableCharacter3.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
            }
        } else if isPlayer3Position {
            
            if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter4.position) < self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter2.position)) {
                duration = Double(self.distanceBetween(point: playableCharacter2.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                
            } else {
                duration = Double(self.distanceBetween(point: playableCharacter4.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition4, duration: duration))
            }
        } else if isPlayer4Position {
            
            if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter5.position) < self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter3.position)) {
                duration = Double(self.distanceBetween(point: playableCharacter3.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                
            } else {
                duration = Double(self.distanceBetween(point: playableCharacter5.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
            }
        } else if isPlayer5Position {
            
            if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter1.position) < self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: playableCharacter3.position)) {
                duration = Double(self.distanceBetween(point: playableCharacter3.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                
            } else {
                duration = Double(self.distanceBetween(point: playableCharacter1.position, andPoint: player.position)) / nonPlayableSpeed
                
                player.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
            }
        }
    }
    
   /* func didBeginContact(contact: SKPhysicsContact) {

        let distance1 = self.distanceBetween(point: ball.position, andPoint: nonPlayableCharacter1.position)
                let distance2 = self.distanceBetween(point: ball.position, andPoint: nonPlayableCharacter2.position)
        let width1 = nonPlayableCharacter1.frame.size.width
        let width2 = nonPlayableCharacter2.frame.size.width
        if (
            ((contact.bodyB.categoryBitMask == nonPlayableCharacterCategory1)
                &&
            contact.bodyA.categoryBitMask == ballCategory
                             && (distance1 < width1 / 2)
                )//nonPlayableCharacter1.size.width / 2))
            ||
            ((contact.bodyB.categoryBitMask == nonPlayableCharacterCategory2)
                &&
        (contact.bodyA.categoryBitMask == ballCategory)
                && (distance2 < width2 / 2)//nonPlayableCharacter2.size.width / 2)
            )
           
            
            
            ) {
          
            
            self.gameOver()
        }
    }*/
    
    func initializeGame() {
        
        //isGameOver = false
        getUserDefaults()
        updateSpeeds()
        
        
        if !isGameStarted {
            createRestartButton()
            //self.initializeLabels()
        }
        initializeLabels()
        
        
                isTouchable = true
        
        initializeCollisionDetection()
        initializeDistances()
        initializeBall()
        self.initializePlayableCharacters()
        self.initializeNonPlayableCharacters()
        self.createNoAdsButton()
        //self.initializeLabels()
        
        
    }
    
    func getUserDefaults() {
        if (defaults == nil) {
            defaults = NSUserDefaults.standardUserDefaults()
        }
        
        if defaults.boolForKey(k_user_default_no_ads) {
            isAdsDisabled = defaults.boolForKey(k_user_default_no_ads)
        }
    }
    
    func preloadInterstitial() {
        print("preloadInterstitial")
        interstitial = GADInterstitial(adUnitID: k_interstitial_id)
        interstitial!.delegate = self
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["16ed9ee524b9056589e1572af4a90966", kGADSimulatorID]
        interstitial!.loadRequest(request)
    }
    
    func interstitialDidDismissScreen (interstitial: GADInterstitial) {
        self.preloadInterstitial()
    }
    
    func initializeRandomAds() {
        numOfGameWithAds = Int(arc4random_uniform(UInt32(k_MAX_RANDOM_VALUE)))
        
            }
    
    func updateSpeeds() {
        let screenWidth:CGFloat = view!.bounds.size.width
        
        if screenWidth == k_IPHONE6_WIDTH {
            ballSpeed = 360.0
            nonPlayableSpeed = 100.0
        } else if screenWidth == k_IPHONE6PLUS_WIDTH {
            // TODO
        } else if screenWidth == k_IPADAIR_WIDTH {
            ballSpeed = 720.0
            nonPlayableSpeed = 300.0
        }
        
        
        
    }
    
    func initializeLabels() {
        
        let record: Int = defaults.integerForKey(k_bestNumberOfPasses)
        
        /* Setup your scene here */
        bestNumberOfPasses = SKLabelNode(fontNamed:"Arial")
        bestNumberOfPasses.text = "Best: \(record)";
        bestNumberOfPasses.fontSize = 30;
        bestNumberOfPasses.position = CGPoint(x:(60), y:(view!.bounds.size.height - 60));
        
        currentNumberOfPasses = SKLabelNode(fontNamed:"Arial")
        currentNumberOfPasses.text = "Passes: \(numberOfPasses)";
        currentNumberOfPasses.fontSize = 30;
        currentNumberOfPasses.position = CGPoint(x:(view!.bounds.size.width - 120), y:(view!.bounds.size.height - 60))
      
      if record > 0 {
        passesToNextTshirt = defaults.integerForKey(k_user_default_passes_to_next_tshirt)
      } else {
        passesToNextTshirt = k_INITIAL_NEXT_TSHIRT_VALUE
      }
      
      passesToNextTshirtLabel = SKLabelNode(fontNamed:"Arial")
      passesToNextTshirtLabel.text = "Passes to next t-shirt: \(passesToNextTshirt)"
      passesToNextTshirtLabel.fontSize = 30
      passesToNextTshirtLabel.position = CGPoint(x:(60), y:(bestNumberOfPasses.position.y - 60))
      
      addChild(passesToNextTshirtLabel)
        addChild(bestNumberOfPasses)
        addChild(currentNumberOfPasses)

    }
    
    func initializeCollisionDetection() {
 /////////////////       self.physicsWorld.contactDelegate = self
    }
    
    func createRestartButton() {
        
        // Create a simple red rectangle that's 100x44
        restartButton = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        // Put it in the center of the scene
        restartButton.position = CGPoint(x:(view!.bounds.size.width / 2), y:(restartButton.frame.height * 2))
        
        if !restartButton.hidden {
            restartButton.hidden = true
        }

//        restartButton.hidden = true
        
        self.addChild(restartButton)
        
    }
    
    func gameOver() {
        
        if defaults != nil && numberOfPasses > defaults.integerForKey(k_bestNumberOfPasses) {
            // Get level info from user defaults
            defaults.setInteger(numberOfPasses, forKey: k_bestNumberOfPasses)
            updateBestNumberOfPassesLabel()
        }
      
      
      
        numberOfPasses = 0
      
        // Update number of passes
        
        isGameOver = true
        isTouchable = false
        
       ////////// restartButton.hidden = false
        //self.scene!.removeAllActions()
        ball.removeAllActions()
        nonPlayableCharacter1.removeAllActions()
        nonPlayableCharacter2.removeAllActions()
        

        nonPlayableCharacter1.removeFromParent()
        nonPlayableCharacter2.removeFromParent()
        playableCharacter1.removeFromParent()
        playableCharacter2.removeFromParent()
        playableCharacter3.removeFromParent()
        playableCharacter4.removeFromParent()
        playableCharacter5.removeFromParent()
                ball.removeFromParent()
       
        bestNumberOfPasses.removeFromParent()
      passesToNextTshirtLabel.removeFromParent()
                currentNumberOfPasses.removeFromParent()
        
        
        currentNumOfGame++
        
        showGameOverMenu()
        
      
            // TODO trigger correct ads
            if (!isAdsDisabled && interstitial!.isReady && Int(arc4random_uniform(UInt32(k_MAX_RANDOM_VALUE))) == K_RANDOM_VALUE_FOR_ADS) {
                interstitial!.presentFromRootViewController(viewController)
            } else if isAdsDisabled {
                print("ADS DISABLED")
            } else if !(interstitial!.isReady) {
                print("interstitial NOT READY")
            } else if Int(arc4random_uniform(UInt32(k_MAX_RANDOM_VALUE))) != K_RANDOM_VALUE_FOR_ADS {
                print("Random value not matching")
            }
      
        
        if passesToNextTshirt <= 0 {
      // new (or a repeated one) tshirt unlocked
      passesToNextTshirt = k_INITIAL_NEXT_TSHIRT_VALUE
      
        
      }
      
      updateNextTshirtInLabel()
      defaults.setInteger(passesToNextTshirt, forKey: k_user_default_passes_to_next_tshirt)
      
        ///////////////????
        initializeGame()
    }
    
    func showGameOverMenu() {
    // appear from down outside the screen to the bottom
     /////////   var menuNode: SKNode!
        
        
        
    }
    
    func updateNumberOfPassesLabel() {
        currentNumberOfPasses.text = "Passes: \(numberOfPasses)"
    }
    
    func updateBestNumberOfPassesLabel() {
        bestNumberOfPasses.text = "Best: \(defaults.integerForKey(k_bestNumberOfPasses))"
    }
  
  func updateNextTshirtInLabel() {
    
    passesToNextTshirtLabel.text = "Passes to next t-shirt: \(passesToNextTshirt)"
  }
  
    func checkPassCut() {
        
        let distance1 = self.distanceBetween(point: ball.position, andPoint: nonPlayableCharacter1.position)
        let distance2 = self.distanceBetween(point: ball.position, andPoint: nonPlayableCharacter2.position)
        let width1 = nonPlayableCharacter1.frame.size.width
        let width2 = nonPlayableCharacter2.frame.size.width
       
        if (distance1 < width1 / 2
            ||
            distance2 < width2 / 2
            ) {
                
                
                gameOver()
        }
    }
    
    func runDefensiveStrategyForTeam(team: CPUTeam) {
        var duration: Double
        
        switch team {
            case CPUTeam.CPU_JAPAN:
                if (self.distanceBetween(point: nonPlayableCharacter1.position, andPoint: ball.position) <= self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: ball.position)) {
                    self.takeDefensiveDecision(nonPlayableCharacter1)
                    self.takePasiveDecision(nonPlayableCharacter2)
                } else {
                    self.takeDefensiveDecision(nonPlayableCharacter2)
                    self.takePasiveDecision(nonPlayableCharacter1)
                }
            
            case CPUTeam.CPU_CHINA:
               //////////////// nonPlayableSpeed = K_CHINA_SPEED_IPHONE
                
                if !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
                    
                if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5) < nonPlayableCharacter2.size.width / 2) {
                    
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition4)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition4, duration: duration))
                    
               // } else if nonPlayableCharacter2.position == initialBallPosition5 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition4) < nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition4, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                    
                //} else if nonPlayableCharacter2.position == initialBallPosition4 {
                   } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3) <
                nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition2)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    
               // } else if nonPlayableCharacter2.position == initialBallPosition3 {
                 } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition2) <
                nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    
               // } else if nonPlayableCharacter2.position == initialBallPosition2 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1) <
                    nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5)) / nonPlayableSpeed

                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))

                } else {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    
                }
            
            }

        case CPUTeam.CPU_NIGERIA:
            if !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
                
                //nonplayablespeed = 
                if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5) < nonPlayableCharacter2.size.width / 2) {
                    
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    // } else if nonPlayableCharacter2.position == initialBallPosition5 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition4) < nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5)) / nonPlayableSpeed
                    
   
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition4, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
                    //} else if nonPlayableCharacter2.position == initialBallPosition4 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3) <
                    nonPlayableCharacter2.size.width / 2) {
                        duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition4)) / nonPlayableSpeed
                        
                        
                        nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                        nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition4, duration: duration))
                        // } else if nonPlayableCharacter2.position == initialBallPosition3 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition2) <
                    nonPlayableCharacter2.size.width / 2) {
                        duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3)) / nonPlayableSpeed
                        
                        nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                        nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                        // } else if nonPlayableCharacter2.position == initialBallPosition2 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1) <
                    nonPlayableCharacter2.size.width / 2) {
                        duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition2)) / nonPlayableSpeed
                        
                        nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                        nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                } else {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                }
                
            }
            
        case CPUTeam.CPU_BRAZIL:
            
            if !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
                
                if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3) < nonPlayableCharacter2.size.width / 2) {
                    
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    
                    // } else if nonPlayableCharacter2.position == initialBallPosition5 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1) < nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                    
                    //} else if nonPlayableCharacter2.position == initialBallPosition4 {
                } else {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition3)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                    
                }
                
            }
            
        case CPUTeam.CPU_SPAIN:
            
            if !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
                
                if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1) < nonPlayableCharacter2.size.width / 2) {
                    
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition3, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition5, duration: duration))
                    
                    // } else if nonPlayableCharacter2.position == initialBallPosition5 {
                } else if (self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition5) < nonPlayableCharacter2.size.width / 2) {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    
                    //} else if nonPlayableCharacter2.position == initialBallPosition4 {
                } else {
                    duration = Double(self.distanceBetween(point: nonPlayableCharacter2.position, andPoint: initialBallPosition1)) / nonPlayableSpeed
                    
                    nonPlayableCharacter1.runAction(SKAction.moveTo(initialBallPosition2, duration: duration))
                    nonPlayableCharacter2.runAction(SKAction.moveTo(initialBallPosition1, duration: duration))
                    
                }
                
            }
            
            default:
                print("default")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        /* Called before each frame is rendered */
        if isGameStarted && !isGameOver {
            switch numOfPlayableCharacters {
                case 5:
                  if numberOfPasses < 15 {
                    if numberOfPassesInARow < 5 {
                      randomCPUTeam()
                    } else {
                      currentTeam = CPUTeam.CPU_NIGERIA.rawValue
                      numberOfPassesInARow = 0
                    }
                  } else if numberOfPasses >= 15 && numberOfPasses < 25 {
                    if numberOfPassesInARow < 3 {
                      randomCPUTeam()
                    } else {
                      currentTeam = CPUTeam.CPU_NIGERIA.rawValue
                      numberOfPassesInARow = 0
                    }
                  } else if numberOfPasses >= 25 && numberOfPasses < 35 {
                    if numberOfPassesInARow < 2 {
                      randomCPUTeam()
                    } else {
                      currentTeam = CPUTeam.CPU_NIGERIA.rawValue
                      numberOfPassesInARow = 0
                    }
                  } else {
                    currentTeam = CPUTeam.CPU_NIGERIA.rawValue
                  }

                  
                    
                    print ("current team \(currentTeam)")
                    //self.runDefensiveStrategyForTeam(testingTeam)
                    runDefensiveStrategyForTeam(CPUTeam(value: currentTeam))
                    
                    //} else {
             //currentTeam = CPUTeam.CPU_NIGERIA.rawValue
          //}
      
                default:
                    print("default")
            }
            
            
            checkPassCut()
            
        }
    }
  
  func randomCPUTeam() {
    //if currentTeam != CPUTeam.CPU_NIGERIA.rawValue && !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
    if !nonPlayableCharacter1.hasActions() && !nonPlayableCharacter2.hasActions() {
      currentTeam = Int(arc4random_uniform(UInt32(k_NUM_TEAMS)))

    }
  }
  
   /* func initializingProductsRequest() {
        //var productID:NSSet = NSSet(object: "no_ads")
        var productID: NSSet = NSSet(object: "com.insaneplatypusgames.Rondo")
        let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }*/
    
    func createNoAdsButton() {
        if !defaults.boolForKey(k_user_default_no_ads) {
            buyButton = UIButton(frame: CGRectMake(100, view!.bounds.height - 40, 200, 40))
            // TODO localice???
            buyButton.setTitle("No Ads", forState: UIControlState.Normal)
            buyButton.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.2, alpha: 1.0)
            buyButton.addTarget(self, action: "buyConsumableNoAds", forControlEvents: UIControlEvents.TouchUpInside)
        
            //////view!.addSubview(buyButton)
        }
    }
    
    
    func buyConsumableNoAds(){
        print("About to fetch the products")
        
        // We check that we are able to make the purchase.
        if (SKPaymentQueue.canMakePayments()) {
            
            let productID: NSSet = NSSet(object:  "no_ads");
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            
            print("Fething Products");
            
        } else{
            print("can not make purchases");
        }
    }
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("got the request from Apple")
        let count : Int = response.products.count
        if (count>0) {
         ////  let validProducts = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == "no_ads") {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    print("Product Purchased");
                    defaults.setBool(true, forKey: k_user_default_no_ads)
                    isAdsDisabled = true
                    buyButton.removeFromSuperview()
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .Failed:
                    print("Purchased Failed");
                    buyButton.removeFromSuperview()
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    // case .Restored:
                    //[self restoreTransaction:transaction];
                default:
                    break;
                }
            }
        }
    }

  func initializeMenuButton() {
    // Initialize UIButton
    menuButton = SKSpriteNode(imageNamed: "soundOffOn")
    menuButton.size = CGSizeMake(nonPlayableCharacter1.frame.width, nonPlayableCharacter1.frame.width)
    menuButton.position = CGPointMake(view!.bounds.size.width - nonPlayableCharacter1.frame.width, nonPlayableCharacter1.frame.width)
//    (frame: CGRectMake(view!.bounds.size.width - nonPlayableCharacter1.frame.width, view!.bounds.size.height - nonPlayableCharacter1.frame.width, nonPlayableCharacter1.frame.width, nonPlayableCharacter1.frame.width))
    // Set image to button
    //menuButton.setImage(UIImage(named: "soundOffOn"), forState: UIControlState.Normal)
    // Specify function to trigger
    
    menuButton.name = "showMenu"
//    menuButton.addTarget(self, action: "showMenu", forControlEvents: UIControlEvents.TouchUpInside)
    // Add button to view
    addChild(menuButton)
  }
  
  func showMenu() {
    scene?.paused = true
    menu = SKSpriteNode(color: UIColor.orangeColor(), size: CGSizeMake(view!.frame.width/2, view!.frame.height/3))
    menu.position = CGPoint(x: CGRectGetMidX(view!.frame), y: CGRectGetMidY(view!.frame))
    menu.zPosition = 100
    addChild(menu)
    
  }
  
  func hideMenu() {
    
  }
  
  /*func showMenu() {
    scene?.paused = true
    let transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
    menuScene = MenuScene(size:  CGSizeMake(50, 50))
    scene!.view?.presentScene(menuScene, transition: transition)
  }
  
  func hideMenu() {
    
    let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
    scene!.view?.presentScene(menuScene, transition: transition)
  }*/
}
