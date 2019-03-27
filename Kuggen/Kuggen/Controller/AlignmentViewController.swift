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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    override func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
        // Called when something in the setup procedure changes.
        // Update view to match the state.
        stateLabel.text = stateString + (inProgress ? connectingString : connectedString)
      
        if (stateLabel.text == connectedString){
            ready()
        }

        
    }
    
    private func setupView() {        

        
    }
    
    override func didStartMainActivity(_ manager: FourInOneSetupManager) {
        coordinator?.goToGameScreen(gameManager: gameManager!)
    }
    
    func ready(){
        didStartMainActivity(self.setupManager)
    }
    
    
}
