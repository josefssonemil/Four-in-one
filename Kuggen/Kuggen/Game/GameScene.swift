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
    
    // Create robots and cogwheel properties
    private let robotOne = Robot(matchingHandle: handleOne, color: UIColor.purple, devicePosition: .one)
    private let robotTwo = Robot(matchingHandle: handleTwo, color: UIColor.blue, devicePosition: .two)
    private let robotThree = Robot(matchingHandle: handleThree, color: UIColor.green, devicePosition: .three)
    private let robotFour = Robot(matchingHandle: handleFour, color: UIColor.yellow, devicePosition: .four)
    private let cogWheel = Cogwheel(handle: handleOne, outer: 1.0, inner: 1.0, current: 1.0, size: 3.0)
    
    
    private var robotController : GameViewController!
    private var cogwheelController : GameViewController!
    
    //var entities = [GKEntity]()
    //var graphs = [String : GKGraph]()
    
    //private var lastUpdateTime : TimeInterval = 0
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
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
     self.lastUpdateTime = 0
     
     // Get label node from scene and store it for use later
     self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
     if let label = self.label {
     label.alpha = 0.0
     label.run(SKAction.fadeIn(withDuration: 2.0))
     }
     
     // Create shape node to use during mouse interaction
     let w = (self.size.width + self.size.height) * 0.05
     self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
     
     if let spinnyNode = self.spinnyNode {
     spinnyNode.lineWidth = 2.5
     
     spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
     spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
     SKAction.fadeOut(withDuration: 0.5),
     SKAction.removeFromParent()]))
     }
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
    
    
    /*func touchDown(atPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.green
     self.addChild(n)
     }
     }
     
     func touchMoved(toPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.blue
     self.addChild(n)
     }
     }
     
     func touchUp(atPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.red
     self.addChild(n)
     }
     }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) }*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO - add functionality
        
        // capture first touch
        if let aTouch = touches.first {
            
            // Store the location of the touch
            let location = aTouch.location(in: self)
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


