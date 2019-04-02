//
//  AlignmentViewController.swift
//  Kuggen
//
//  Created by Alexander Nordgren on 2019-03-14.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore

class AlignmentViewController: FourInOneConnectingViewController, Storyboarded {

    weak var coordinator: MainCoordinator?

    var gameManager : KuggenSessionManager!
    
 
    private let stateString = "State: "
    private let connectedString = "Placera iPadarna så att färgerna matchar"
    private let connectingString = "Letar andra spelare"
    
    private let oneTwo = UIColor.init(red: 0xe5/255, green: 0x99/255, blue: 0xde/255, alpha: 100)
    private let oneFour = UIColor.init(red: 0xd8/255, green: 0xc2/255, blue: 0xff/255, alpha: 100)
    private let twoThree = UIColor.init(red: 0x97/255, green: 0xd4/255, blue: 0xdf/255, alpha: 100)
    private let threeFour = UIColor.init(red: 0xc2/255, green: 0xd8/255, blue: 0xff/255, alpha: 100)
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var loadingCog: UIImageView!
    

    @IBAction func next(_ sender: Any) {
        //didStartMainActivity(self.setupManager)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        setupManager.readyAndWaitingForPeers()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        setupManager.cancelReadyAndWaiting()
    
    }

    @IBOutlet weak var longBorder: UIImageView!
    @IBOutlet weak var shortBorder: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        shortBorder.isHidden=true
        longBorder.isHidden=true
        super.viewDidLoad()
        self.debugMode = true
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.loadingCog.transform = CGAffineTransform(rotationAngle: (.pi))
        })
        setupStartView()
    }
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.start()
    }
    private func setupGame(){
        setupManager.delegate = self
        
        //var gameManager: KuggenSessionManager!
        
        if setupManager.isServer {
            self.gameManager = KuggenSessionServer()
            print("gamemanger is server")
        }
        else {
           self.gameManager = KuggenSessionClient()
            print("game manager is client")
        }
        
        print("initsessionManager method")
        setupManager.initSessionManager(self.gameManager)
        self.gameManager.team = self.team
        self.gameManager.position = setupManager.position
        self.gameManager.platform = .spritekit
        
        setupManager.finishSetup()
    
        
    }
    
    
    override func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
        // Called when something in the setup procedure changes.
        // Update view to match the state.
        // All the visible stuff should be here
        loadingCog.transform = CGAffineTransform.identity
        switch position {
        case DevicePosition.one:
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: 0, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: 0)
            UIView.animate(withDuration: 2.0, animations: {
                self.loadingCog.center.y=0
                self.loadingCog.center.x=self.view.bounds.width
                self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.longBorder.backgroundColor = self.oneTwo
                self.shortBorder.backgroundColor = self.oneFour
                self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: -self.view.bounds.width, height: 50)
                self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: self.view.bounds.height)
                //self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: 50)
            })
        case DevicePosition.two:
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: 0, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: 0)
            UIView.animate(withDuration: 2.0, animations: {
                self.loadingCog.center.y=self.view.bounds.height
                self.loadingCog.center.x=self.view.bounds.width
                self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.longBorder.backgroundColor = self.oneTwo
                self.shortBorder.backgroundColor = self.twoThree
                //self.longBorder.center.y = self.view.bounds.height-25
                self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: -self.view.bounds.width, height: 50)
                self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: -self.view.bounds.height)
            })
        case DevicePosition.three:
            self.longBorder.frame = CGRect(x: 0, y: self.view.bounds.height-50, width: 0, height: 50)
            self.shortBorder.frame = CGRect(x: 0, y: self.view.bounds.height, width: 50, height: 0)
            UIView.animate(withDuration: 2.0, animations: {
                self.loadingCog.center.y=self.view.bounds.height
                self.loadingCog.center.x=0
                self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.longBorder.backgroundColor = self.threeFour
                self.shortBorder.backgroundColor = self.twoThree
                //self.longBorder.center.y = self.view.bounds.height-25
                //self.shortBorder.center.x = 25
                self.longBorder.frame = CGRect(x: 0, y: self.view.bounds.height-50, width: self.view.bounds.width, height: 50)
                self.shortBorder.frame = CGRect(x: 0, y: self.view.bounds.height, width: 50, height: -self.view.bounds.height)
            })
        case DevicePosition.four:
            self.longBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
            self.shortBorder.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            UIView.animate(withDuration: 2.0, animations: {
                self.loadingCog.center.y=0
                self.loadingCog.center.x=0
                self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.longBorder.backgroundColor = self.threeFour
                self.shortBorder.backgroundColor = self.oneFour
                //self.shortBorder.center.x=25
                self.longBorder.frame = CGRect(x: 0, y: 50, width: self.view.bounds.width, height: 50)
                self.shortBorder.frame = CGRect(x: 0, y: 0, width: 50, height: self.view.bounds.height)
            })
        default:
            break
        }
        shortBorder.isHidden=false
        longBorder.isHidden=false

        stateLabel.text = (inProgress ? connectingString : connectedString + position.rawValue.description)
            }
    
    private func setupStartView() {
        
        showDebugInfo(type: .starting)
        teamLabel.isHidden = true
        idLabel.isHidden = true
        serverLabel.isHidden = true
        peersLabel.isHidden = true
        
        stateLabel.text = connectingString
        /*if !debugMode {
            

            
        }*/
    }
    
    override func didStartMainActivity(_ manager: FourInOneSetupManager) {
        setupGame()
        if (gameManager !== nil){
            coordinator?.goToGameScreen(gameManager: gameManager!)
        }
        else{
            print("gamemanager:", gameManager?.description as Any)
        }

    }
    
    
    
}
