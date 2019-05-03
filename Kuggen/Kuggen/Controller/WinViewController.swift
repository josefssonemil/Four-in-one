//
//  WinViewController.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-04-23.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore

class WinViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var gameManager : KuggenSessionManager!
    //@IBOutlet weak var playAgainButton: MenuButton!
    
    
    @IBAction func playAgainTapped(_ sender: Any) {
        coordinator?.goToGameScreen(gameManager: gameManager)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        coordinator?.start()
    }
    
    @IBAction override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, animations: {
            
       /*     self.longBorder.alpha = 0
            self.shortBorder.alpha = 0
            self.stateLabel.center.y = self.view.bounds.height/2
            self.stateLabel.center.x = self.view.bounds.width/2 - 160
            self.loadingCog.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.loadingCog.center.y = self.view.bounds.height/2
            self.loadingCog.center.x = self.view.bounds.width/2 + 160
            self.backButton.center.y = self.view.bounds.height-75
            self.backButton.center.x = self.view.bounds.width/2
 */
        })
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
           // self.loadingCog.transform = CGAffineTransform(rotationAngle: (.pi))
        })
    }
}

