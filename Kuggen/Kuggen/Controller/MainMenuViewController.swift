//
//  PreMainMenuViewController.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-15.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    private let help = ["För att starta ett spel, peka på spel" , "För att välja hur din robot ska se ut, peka på Byt robot", "För att ändra inställningar, peka på Inställningar", "Vill du veta mer om oss? Klicka här!"]
    private var helpCount = 0
    
    @IBOutlet weak var playButton: MenuButton!
    @IBOutlet weak var selectRobotMenuButton: MenuButton!
    @IBOutlet weak var optionMenuButton: MenuButton!
    @IBOutlet weak var robotButton: UIButton!
    @IBOutlet weak var speechBubble: UIImageView!
    @IBOutlet weak var speechLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.speechLabel.text = "Hej, peka på mig för att få hjälp"
        selectRobotMenuButton.isHidden=true
        optionMenuButton.isHidden=true
        UIView.animate(withDuration: 0.5, delay: 1, animations: {
            self.speechLabel.alpha=1.0
            self.speechBubble.alpha=1.0
        }, completion: {
            (finished) in
            UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                //self.speechLabel.alpha=0.0
                //self.speechBubble.alpha=0.0
            })
        })
    }
    override func viewDidLoad() {
        aboutButton.alpha=0
        speechLabel.alpha = 0
        speechBubble.alpha = 0
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.robotButton.setImage(UIImage(named: "robotBlink"), for: .highlighted)
        
    }
    @IBAction func robotTapped(_ sender: Any) {
        var about = CGFloat(0.0)
        if(!(helpCount < help.count)){
            helpCount=0
        }
        self.speechLabel.text = help[helpCount]
        if (helpCount == 3) {
            about=1.0
            
        }
        helpCount+=1
        UIView.animate(withDuration: 0.5, animations: {
            self.speechLabel.alpha=1.0
            self.speechBubble.alpha=1.0
            self.aboutButton.alpha=about
        }, completion: {
            (finished) in
            UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                about=0.0
               // self.speechLabel.alpha=0.0
                //self.speechBubble.alpha=0.0
                //self.aboutButton.alpha=about
            })
        })
      
    }
    @IBAction func aboutTapped(_ sender: Any) {
        coordinator?.goToAbout()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        //LevelReader.createLevel(nameOfLevel: "level2")
        coordinator?.goToTeamSelection()

    }
    /*@IBAction func buttonTapped(_ sender: Any) {
        print("whyyyyyy")
        coordinator?.goToWinView()
    }*/
    
    @IBAction func selectRobotMenuTapped(_ sender: Any) {
        coordinator?.goToRobotSelection()
    }
    
    @IBAction func optionMenuTapped(_ sender: Any) {
        coordinator?.goToOptionsView()
    }
    
}
