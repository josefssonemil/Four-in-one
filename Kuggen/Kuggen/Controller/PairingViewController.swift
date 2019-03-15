//
//  PairingViewController.swift
//  Kuggen
//

import UIKit
import FourInOneCore

class PairingViewController : FourInOneConnectingViewController, Storyboarded {
    
    
    // Coordinator which handles navigation between views
    weak var coordinator: MainCoordinator?
    
    
    // Assigns delegate and starts the setup of the 4-in-1 session
    func setupPhase(){
        setupManager.delegate = self
        setupManager.startSetup()
    }
    
    
    
    override func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
    }

    
    // Makes connection by informing the setupManager that this device is ready to start the session
    // The setupManager will let the delegate know when all devices are ready
    func makeConnection(){
        //Wait for all devices to be ready
        setupManager.readyAndWaitingForPeers()
        
        // The gameManager which will control the game
        var gameManager : KuggenSessionManager
        
        if setupManager.isServer {
            gameManager = KuggenSessionServer()
        }
        else {
            gameManager = KuggenSessionClient()
        }
        
        setupManager.initSessionManager(gameManager)
        gameManager.team = self.team
        gameManager.platform = .spritekit
        setupManager.finishSetup()
        
        // relay: team, game manager, setup manager should not be needed after this!
        coordinator?.goToAlignmentScreen(team: self.team, gameManager: gameManager)
    }
    @IBAction func teamOneTapped(_ sender: Any) {
        self.team = 1
        makeConnection()
    }
    @IBAction func teamTwotapped(_ sender: Any) {
        self.team = 2
        makeConnection()
    }
    @IBAction func teamThreeTapped(_ sender: Any) {
        self.team = 3
        makeConnection()
    }
    
    @IBAction func teamFourTapped(_ sender: Any) {
        self.team = 4
        makeConnection()
    }
    
    @IBAction func teamFiveTapped(_ sender: Any) {
        self.team = 5
        makeConnection()
    }
    
    @IBAction func teamSixTapped(_ sender: Any) {
        self.team = 6
        makeConnection()
    }
    
    @IBAction func teamSevenTapped(_ sender: Any) {
        self.team = 7
        makeConnection()
    }
    @IBAction func teamEightTapped(_ sender: Any) {
        self.team = 8
        makeConnection()
    }
}

