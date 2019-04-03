//
//  PairingViewController.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity

class TeamSelectionViewController: UIViewController, Storyboarded {
    
    
    // Coordinator which handles navigation between views
    weak var coordinator: MainCoordinator?
    var team = 0
    

    @IBOutlet weak var teamButton1: UIButton!
    @IBOutlet weak var teamButton2: UIButton!
    @IBOutlet weak var teamButton3: UIButton!
    @IBOutlet weak var teamButton4: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        
        backButton.center.y = 75
        backButton.center.x = 75
        let border = CGFloat(1.0)
        let color = UIColor.black.cgColor
        
        teamButton1.layer.borderWidth = border
        teamButton1.layer.borderColor = color
        teamButton2.layer.borderWidth = border
        teamButton2.layer.borderColor = color

        teamButton3.layer.borderWidth = border
        teamButton3.layer.borderColor = color

        teamButton4.layer.borderWidth = border
        teamButton4.layer.borderColor = color
    }

    
    @IBAction func backButtonTapped(_ sender: Any) {
        coordinator?.start()
    }
    

    @IBAction func teamOneTapped(_ sender: Any) {
        self.team = 1
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")
    }
    @IBAction func teamTwotapped(_ sender: Any) {
        self.team = 2
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")

    }
    @IBAction func teamThreeTapped(_ sender: Any) {
        self.team = 3
        coordinator?.goToAlignmentScreen(team: self.team)
        print("team tapped")

    }
    
    @IBAction func teamFourTapped(_ sender: Any) {
        self.team = 4
        coordinator?.goToAlignmentScreen(team: self.team)

        print("team tapped")

    }
    
}

