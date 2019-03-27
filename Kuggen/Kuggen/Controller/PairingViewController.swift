//
//  PairingViewController.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity

class PairingViewController: UIViewController, Storyboarded {
    
    
    // Coordinator which handles navigation between views
    weak var coordinator: MainCoordinator?
    var team = 0
    
    // Assigns delegate and starts the setup of the 4-in-1 session
    /*func setupPhase(){
        print("setup phase")

        setupManager?.delegate = self
        setupManager?.startSetup()
        setupManager.readyAndWaitingForPeers()

    }*/
    


    
    // Makes connection by informing the setupManager that this device is ready to start the session
    // The setupManager will let the delegate know when all devices are ready
    func makeConnection(){
        
        /*setupPhase()
        //Wait for all devices to be ready
        print("waiting for peers")

        
        // The gameManager which will control the game
        var gameManager : KuggenSessionManager
        
        if setupManager.isServer {
            print("server is manager")

            gameManager = KuggenSessionServer()
        }
        else {
            print("client is manager")

            gameManager = KuggenSessionClient()
        }
        
        setupManager.initSessionManager(gameManager)
        gameManager.team = self.team
        gameManager.platform = .spritekit
        setupManager.finishSetup()
        print("setup finished")*/

        // relay: team, game manager, setup manager should not be needed after this!
        //coordinator?.goToAlignmentScreen(team: self.team)
    }
    
    

    @IBAction func teamOneTapped(_ sender: Any) {
        self.team = 1
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")
    }
    @IBAction func teamTwotapped(_ sender: Any) {
        self.team = 2
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")

    }
    @IBAction func teamThreeTapped(_ sender: Any) {
        self.team = 3
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")

    }
    
    @IBAction func teamFourTapped(_ sender: Any) {
        self.team = 4
        coordinator?.goToAlignmentScreen(team: self.team)

        print("team tapped")

    }
    
    @IBAction func teamFiveTapped(_ sender: Any) {
        self.team = 5
        print("team tapped")

    }
    
    @IBAction func teamSixTapped(_ sender: Any) {
        self.team = 6
        print("team tapped")

    }
    
    @IBAction func teamSevenTapped(_ sender: Any) {
        self.team = 7
        print("team tapped")

    }
    @IBAction func teamEightTapped(_ sender: Any) {
        self.team = 8
        print("team tapped")

    }
}

