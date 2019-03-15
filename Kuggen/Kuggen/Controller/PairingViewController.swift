//
//  PairingViewController.swift
//  Kuggen
//

import UIKit
import FourInOneCore
// TODO: Add actual views to the controller and make a suitable method for making the devices
// aligned correctly

class PairingViewController : FourInOneConnectingViewController, Storyboarded {
    
    
    @IBAction func teamOneTapped(_ sender: Any) {
    }
    @IBAction func teamTwotapped(_ sender: Any) {
    }
    @IBAction func teamThreeTapped(_ sender: Any) {
    }
    
    @IBAction func teamFourTapped(_ sender: Any) {
    }
    
    @IBAction func teamFiveTapped(_ sender: Any) {
    }
    
    @IBAction func teamSixTapped(_ sender: Any) {
    }
    
    @IBAction func teamSevenTapped(_ sender: Any) {
    }
    @IBAction func teamEightTapped(_ sender: Any) {
    }
    
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
        
        coordinator?.goToGameScreen()
    }
    
}

