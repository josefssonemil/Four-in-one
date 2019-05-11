//
//  OptionsViewController.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class OptionsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    //Variables for the objects on screen
    @IBOutlet weak var backButton: UIButton!

    //Go back to main menu
    @IBAction func backButtonTapped (_ sender: Any){
        coordinator?.start()
    }
}
