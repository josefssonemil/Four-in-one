//
//  RobotSelectorViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import SpriteKit

class RobotSelectorViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var robot1Button: UIButton!
    @IBOutlet weak var robot2Button: UIButton!
    @IBOutlet weak var robot3Button: UIButton!
    @IBOutlet weak var robot4Button: UIButton!
    
    @IBAction func robot1Selected(_ sender: Any) {
        robot1Button.isHighlighted = true
        robot2Button.isHighlighted = false
        robot3Button.isHighlighted = false
        robot4Button.isHighlighted = false

    }
    
    @IBAction func robot2Selected(_ sender: Any) {
        robot2Button.isHighlighted = true
        robot1Button.isHighlighted = false
        robot3Button.isHighlighted = false
        robot4Button.isHighlighted = false

    }
    
    
    @IBAction func robot3Selected(_ sender: Any) {
        robot3Button.isHighlighted = true
        robot2Button.isHighlighted = false
        robot3Button.isHighlighted = false
        robot4Button.isHighlighted = false
    }
    
    @IBAction func robot4Selected(_ sender: Any) {
        robot4Button.isHighlighted = true
        robot1Button.isHighlighted = false
        robot3Button.isHighlighted = false
        robot2Button.isHighlighted = false

    }
    
    @IBAction func nextTapped(_ sender: Any) {
        coordinator?.goToPairingScreen()
        // TODO: send robot selected to next screens
    }
    
}
