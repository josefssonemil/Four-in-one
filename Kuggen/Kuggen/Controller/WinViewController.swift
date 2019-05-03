//
//  WinViewController.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-04-23.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class WinViewController: UIViewController, Storyboarded {
    var gameManager: KuggenSessionManager?
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var playAgainButton: MenuButton!
    
    @IBOutlet weak var menuTapped: MenuButton!
    
    @IBAction func playAgainTapped(_ sender: Any) {
//    coordinator?.goToGameScreen(gameManager: <#T##KuggenSessionManager#>)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        coordinator?.start()
    }
}

