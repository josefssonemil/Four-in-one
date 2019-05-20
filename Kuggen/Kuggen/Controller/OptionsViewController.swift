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
    @IBOutlet weak var angleEpsLabel: UILabel!
    @IBOutlet weak var angleEpsStepper: UIStepper!
    
    
    override func viewDidLoad() {
        //Set correct text
        self.angleEpsLabel.text = "\(Constants.angleEps)°"
        
        //Configure stepper
        self.angleEpsStepper.wraps = true
        self.angleEpsStepper.autorepeat = true
        self.angleEpsStepper.minimumValue = 1
        self.angleEpsStepper.maximumValue = 20
        angleEpsStepper.value = Double(Constants.angleEps)
    }

    //Go back to main menu
    @IBAction func backButtonTapped (_ sender: Any){
        coordinator?.start()
    }
    
    @IBAction func stepperChangedValue(_ sender: UIStepper){
        angleEpsLabel.text = Int(sender.value).description + "°"
        Constants.angleEps = Int(sender.value)
    }
}
