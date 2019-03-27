//
//  GameViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-07.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import FourInOneCore

class GameViewController: FourInOneSessionViewController, Storyboarded, GameSceneDelegate {
    
    
    func gameScene(_ gameScene: GameScene, didEndLevelWithSuccess result: Bool) {
        fatalError("init(coder:) has not been implemented")

    }
    
    
    weak var coordinator: MainCoordinator?

    var gameManager: KuggenSessionManager!
    var gameScene : GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutGameScene()
    }

    private func layoutGameScene() {
        
        if let boardView = self.boardView as! SKView? {
            gameScene = GameScene(size: UIScreen.main.bounds.size)
            gameScene.gameManager = gameManager as? KuggenSessionManager
            gameScene.scaleMode = .aspectFill
            //gameScene.gameSceneDelegate = self

            boardView.ignoresSiblingOrder = false
            boardView.presentScene(gameScene)
            sessionManager.startSession()
        }
    }

    

   /* override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }*/
}
