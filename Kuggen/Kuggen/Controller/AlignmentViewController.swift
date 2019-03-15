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
    
    
    
    override func didStartMainActivity(_ manager: FourInOneSetupManager) {
        coordinator?.goToGameScreen(gameManager: gameManager!)
    }
    
    func ready(){
        didStartMainActivity(self.setupManager)
    }
    
    
}
