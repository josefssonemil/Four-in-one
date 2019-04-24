//
//  WinViewController.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-04-23.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class WinViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var gameManager : KuggenSessionManager!
    //@IBOutlet weak var playAgainButton: MenuButton!
    
    
    @IBAction func playAgainTapped(_ sender: Any) {
    coordinator?.goToGameScreen(gameManager: gameManager)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        coordinator?.start()
    }
}

