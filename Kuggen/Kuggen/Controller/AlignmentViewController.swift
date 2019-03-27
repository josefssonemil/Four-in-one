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

    var gameManager : KuggenSessionManager?
    
 
    private let stateString = "State: "
    private let connectedString = "Connected"
    private let connectingString = "Connecting"
    
    @IBOutlet weak var stateLabel: UILabel!

    @IBAction func next(_ sender: Any) {
        didStartMainActivity(self.setupManager)
        coordinator?.goToGameScreen(gameManager: gameManager!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugMode = false
        setupStartView()
        startConnection()
    }
    
    private func startConnection(){
        setupManager.readyAndWaitingForPeers()
        
        var gameManager: KuggenSessionManager
        
        if setupManager.isServer{
            gameManager = KuggenSessionServer()
        }
        else {
            gameManager = KuggenSessionClient()
        }
        
        setupManager.initSessionManager(gameManager)
        gameManager.team = self.team
        gameManager.platform = .spritekit
        
    }
    
    private func cancelConnection(){
        setupManager.cancelReadyAndWaiting()
    }
    
    override func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
        // Called when something in the setup procedure changes.
        // Update view to match the state.
        // All the visible stuff should be here
        stateLabel.text = stateString + (inProgress ? connectingString : connectedString)

        
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
    
    
    
}
