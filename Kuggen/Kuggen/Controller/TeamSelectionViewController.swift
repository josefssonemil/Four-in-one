//
//  PairingViewController.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity

class TeamSelectionViewController: UIViewController, Storyboarded {
    
    
    // Coordinator which handles navigation between views
    weak var coordinator: MainCoordinator?
    var team = 0
    
    @IBOutlet weak var teamButton1: UIButton!
    @IBOutlet weak var teamButton2: UIButton!
    @IBOutlet weak var teamButton3: UIButton!
    @IBOutlet weak var teamButton4: UIButton!
    
    override func viewDidLoad() {
        let border = CGFloat(1.0)
        let color = UIColor.black.cgColor
        teamButton1.layer.borderWidth = border
        teamButton1.layer.borderColor = color
        teamButton2.layer.borderWidth = border
        teamButton2.layer.borderColor = color

        teamButton3.layer.borderWidth = border
        teamButton3.layer.borderColor = color

        teamButton4.layer.borderWidth = border
        teamButton4.layer.borderColor = color
    }
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
    
}

