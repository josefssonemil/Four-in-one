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
    @IBOutlet weak var selectRobotMenuButton: MenuButton!
    @IBOutlet weak var optionMenuButton: MenuButton!

    
    @IBAction func playTapped(_ sender: Any) {
        coordinator?.goToMainMenu()
    }
    
    @IBAction func selectRobotMenuTapped(_ sender: Any) {
        coordinator?.goToRobotSelection()
    }
    
    @IBAction func optionMenuTapped(_ sender: Any) {
        coordinator?.goToOptionsView()
    }
    
}
