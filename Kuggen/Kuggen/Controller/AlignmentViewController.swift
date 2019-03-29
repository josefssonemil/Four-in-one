//
//  AlignmentViewController.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-03-14.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore

class AlignmentViewController: FourInOneConnectingViewController, Storyboarded {

    weak var coordinator: MainCoordinator?

    var gameManager : KuggenSessionManager!
    
 
    private let stateString = "State: "
    private let connectedString = "Connected"
    private let connectingString = "Connecting"
    
    @IBOutlet weak var stateLabel: UILabel!
<<<<<<< HEAD

    @IBAction func next(_ sender: Any) {
        //didStartMainActivity(self.setupManager)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        setupManager.readyAndWaitingForPeers()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        setupManager.cancelReadyAndWaiting()
        
=======
    @IBOutlet weak var rotateImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.rotateImage.transform = CGAffineTransform(rotationAngle: (45.0 * .pi) / 45.0)
        })
>>>>>>> adding a cogwheel to show which way to align the ipad
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugMode = true
        setupStartView()
    }
    
    private func setupGame(){
        setupManager.delegate = self
        
        //var gameManager: KuggenSessionManager!
        
        if setupManager.isServer {
            self.gameManager = KuggenSessionServer()
            print("gamemanger is server")
        }
        else {
           self.gameManager = KuggenSessionClient()
            print("game manager is client")
        }
        
        print("initsessionManager method")
        setupManager.initSessionManager(self.gameManager)
        self.gameManager.team = self.team
        self.gameManager.position = setupManager.position
        self.gameManager.platform = .spritekit
        
        setupManager.finishSetup()
    
        
    }
    
    
    override func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
        // Called when something in the setup procedure changes.
        // Update view to match the state.
        // All the visible stuff should be here
        stateLabel.text = stateString + (inProgress ? connectingString : connectedString)
<<<<<<< HEAD

=======
>>>>>>> adding a cogwheel to show which way to align the ipad
        
    }
    
    private func setupStartView() {
        
        showDebugInfo(type: .starting)
        
        /*if !debugMode {
            
            teamLabel.isHidden = true
            idLabel.isHidden = true
            serverLabel.isHidden = true
            peersLabel.isHidden = true
            
        }*/
    }
    
    override func didStartMainActivity(_ manager: FourInOneSetupManager) {
        setupGame()
        if (gameManager !== nil){
            coordinator?.goToGameScreen(gameManager: gameManager!)
        }
        else{
            print("gamemanager:", gameManager?.description as Any)
        }

    }
    
    
    
}
