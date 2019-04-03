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
    
    private let help = ["Välj ett lag att spela med" , "Alla du vill spela med måste välja samma lag", "Blipp!"]
    private var helpCount = 0

    @IBOutlet weak var teamButton1: UIButton!
    @IBOutlet weak var teamButton2: UIButton!
    @IBOutlet weak var teamButton3: UIButton!
    @IBOutlet weak var teamButton4: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var helpBubble: UIImageView!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        helpButton.setImage(UIImage(named: "robotBlink"), for: .highlighted)
        helpBubble.alpha=0
        helpLabel.alpha=0
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

    
    @IBAction func helpButtonTapped(_ sender: Any) {
        if(!(helpCount < help.count)){
            helpCount=0
        }
        self.helpLabel.text = help[helpCount]
        helpCount+=1
        UIView.animate(withDuration: 0.5, animations: {
            self.helpLabel.alpha=1.0
            self.helpBubble.alpha=1.0
        }, completion: {
            (finished) in
            UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                self.helpLabel.alpha=0.0
                self.helpBubble.alpha=0.0
            })
        })
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

