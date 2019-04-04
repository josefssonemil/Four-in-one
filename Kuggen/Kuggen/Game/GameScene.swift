//
//  GameScene.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-07.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import SpriteKit
import FourInOneCore
import MultipeerConnectivity
import GameplayKit

// Protocol for game over
protocol GameSceneDelegate {
    func gameScene(_ gameScene:GameScene, didEndLevelWithSuccess result:Bool)
    
}

private let handleOne = Handle.edgeCircle
private let handleTwo = Handle.edgeSquare
private let handleThree = Handle.edgeTrapezoid
private let handleFour = Handle.edgeTriangle


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Game manager, create and manage request objects
    var gameManager : KuggenSessionManager!
    var gameScenDelegate : GameSceneDelegate?
    private var latestPoint = CGPoint()
    var limit : CGFloat = 6.0

    // Create robots and cogwheel properties
    private let robotOne = Robot(matchingHandle: handleOne, devicePosition: .one, textureName: "robot_1")
    private let robotTwo = Robot(matchingHandle: handleTwo, devicePosition: .two, textureName: "robot_2")
    private let robotThree = Robot(matchingHandle: handleThree, devicePosition: .three, textureName: "robot_3")
    private let robotFour = Robot(matchingHandle: handleFour, devicePosition: .four, textureName: "robot_4")
    private let cogWheel = Cogwheel(handle: handleOne, outer: 1.0, inner: 1.0, current: 1.0, size: CGSize.init(width: 3.0, height: 3.0), color: UIColor.blue)
    

    
    // Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Initalize new scene object
    override init(size: CGSize) {
        super.init(size : size)
    }
    
    // When scene is presented by view
    override func didMove(to view: SKView) {
        // setup the scene
        self.layoutScene()
    }
    
    /*override func sceneDidLoad() {
   
     }*/
    
    
    // Setup the scene, add scenes and behaviours
    func layoutScene() {
        // Test
        print("Scene Setup")
        // data is sent once and is not sent again if a transmission error occurs
        gameManager.sendDataMode = .unreliable
        gameManager.delegate = self as FourInOneSessionManagerDelegate
        
        // set the background color
        self.backgroundColor = SKColor.white
        
   
        
        // Physics - Setup physics here
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Game manager, set up the robot and cogwheel properties
        self.gameManager.robotOne = robotOne
        self.gameManager.robotTwo = robotTwo
        self.gameManager.robotThree = robotThree
        self.gameManager.robotFour = robotFour
        self.gameManager.cogWheel = cogWheel
        
        // add nodes to scene
        if gameManager.mode == .twoplayer
        {
            self.addChild(robotOne)
            self.addChild(robotTwo)
            robotOne.name = "robot_1"
            robotTwo.name = "robot_2"
            //self.addChild(cogWheel)

        }
        
        else if gameManager.mode == .fourplayer{
            self.addChild(robotOne)
            self.addChild(robotTwo)
            self.addChild(robotThree)
            self.addChild(robotFour)
            robotOne.name = "robot_1"
            robotTwo.name = "robot_2"
            robotThree.name = "robot_3"
            robotFour.name = "robot_4"
            //self.addChild(cogWheel)

        }
        
        else {
            self.addChild(robotOne)
            robotOne.name = "robot_1"
            //self.addChild(cogWheel)
        }
    
        self.gameManager.initialSetUp()
        
    }
    
    // Update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        /*if (self.lastUpdateTime == 0) {
         self.lastUpdateTime = currentTime
         }
         
         // Calculate time since last update
         let dt = currentTime - self.lastUpdateTime
         
         // Update entities
         for entity in self.entities {
         entity.update(deltaTime: dt)
         }
         
         self.lastUpdateTime = currentTime*/
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        
    }
    

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
     
        if let aTouch = touches.first {
            
            let location = aTouch.location(in: self)
            
            // Check that there's som significant move
            // or else do not care about touch at all
            let diffX = abs(location.x-latestPoint.x)
            let diffY = abs(location.y-latestPoint.y)
          
            
            if diffX+diffY > limit {
                
                // Remember this location
                latestPoint = location
                
                let touchedNode = atPoint(location)
                
                if let nodeName = touchedNode.name {
                    
                    if nodeName.contains("robot") {
                        
                        if let touchedRobot = touchedNode as? Robot  {
                            let prevLoc = aTouch.previousLocation(in: self)
                            // TODO, make arm stretch
                            
                            let dx = location.x - prevLoc.x
                            let dy = location.y - prevLoc.y
                            
                            let deltaX = location.x - touchedRobot.position.x
                            let deltaY = location.y - touchedRobot.position.y
                            
                            // When arm is rotated, there should be an angle limit in both directions
                            let angle = atan2(deltaY, deltaX) - (.pi / 2)

                            
                            gameManager.armMoved(robot: touchedRobot, angle: angle)
                            
                        }
                        
                    }
                }
                
                
            }
            else {
                
               // if kDebug {
                  //  print("skipped, small limit value")
             //   }
                
            }
            
        }
        
        /*for t in touches { self.touchMoved(toPoint: t.location(in: self)) }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches { self.touchUp(atPoint: t.location(in: self)) }*/
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches { self.touchUp(atPoint: t.location(in: self)) }*/
    }
    
    // MARK: contact begin between two bodies
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    // contact end
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * .pi)
    }
}



extension GameScene : KuggenSessionManagerDelegate {
    
    func gameManager(_ manager: KuggenSessionManagerDelegate, moveMid newCenter: CGPoint, deviceAt position:DevicePosition) {
        
    }
    
    /*func gameManager(_ manager: KuggenSessionManagerDelegate, newLevel:Level) {
     
     }*/
    
    /*func gameManager(_ manager: KuggenSessionManagerDelegate, endedLevel: Level?, success: Bool) {
     
     gameSceneDelegate?.gameScene(self, didEndLevelWithSuccess: success)
     
     }*/
    
    func gameManagerGameOver(_ manager: KuggenSessionManager) {
        
    }
    
    func gameManagerNextLevel(_ manager: KuggenSessionManager) {
        
    }
    
    func sessionManager(_ manager: FourInOneSessionManager, lostPeer: MCPeerID) {
        
        
    }
    
}


