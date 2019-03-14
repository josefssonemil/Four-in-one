//
//  RobotSelectorViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import SpriteKit

class RobotConfigurationViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    
    //Robot
    var team = 0

    @IBOutlet weak var robot1Button: UIButton!
    @IBOutlet weak var robot2Button: UIButton!
    @IBOutlet weak var robot3Button: UIButton!
    @IBOutlet weak var robot4Button: UIButton!
    
    @IBAction func robot1Selected(_ sender: Any) {
        robot1Button.isSelected = true
        robot2Button.isSelected = false
        robot3Button.isSelected = false
        robot4Button.isSelected = false
        team = 1

    }
    
    @IBAction func robot2Selected(_ sender: Any) {
        robot2Button.isSelected = true
        robot1Button.isSelected = false
        robot3Button.isSelected = false
        robot4Button.isSelected = false
        team = 2
    }
    
    
    @IBAction func robot3Selected(_ sender: Any) {
        robot3Button.isSelected = true
        robot2Button.isSelected = false
        robot1Button.isSelected = false
        robot4Button.isSelected = false
        team = 3
    }
    
    @IBAction func robot4Selected(_ sender: Any) {
        robot4Button.isSelected = true
        robot2Button.isSelected = false
        robot3Button.isSelected = false
        robot1Button.isSelected = false
        team = 4

    }
    
    @IBAction func nextTapped(_ sender: Any) {
        coordinator?.goToPairingScreen(team: team)
        // TODO: send robot selected to next screens
        // Also causes a crash due to the pairing phase not being implemented completely yet
    }
    
}
