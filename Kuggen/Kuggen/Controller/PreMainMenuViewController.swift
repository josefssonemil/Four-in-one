//
//  PreMainMenuViewController.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-15.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class PreMainMenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var playButton: MenuButton!

    
    @IBAction func nextTapped(_ sender: Any) {
        coordinator?.goToMainMenu()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        coordinator?.goToMainMenu()
    }
}
