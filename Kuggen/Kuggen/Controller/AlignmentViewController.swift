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
    
    private let help = ["Jag letar efter fler spelare" , "Ni måste vara minst två spelare", "Ni kan vara högst 4 spelare!"]
    private var helpCount = 0
 
    private let stateString = "State: "
    private let connectedString = "Placera iPadarna så att färgerna matchar"
    private let connectingString = "Letar andra spelare"
    
    private var inProgress = true
    
    private let oneTwo = UIColor.init(red: 0xe5/255, green: 0x99/255, blue: 0xde/255, alpha: 100)
    private let oneFour = UIColor.init(red: 0xd8/255, green: 0xc2/255, blue: 0xff/255, alpha: 100)
    private let twoThree = UIColor.init(red: 0x97/255, green: 0xd4/255, blue: 0xdf/255, alpha: 100)
    private let threeFour = UIColor.init(red: 0xc2/255, green: 0xd8/255, blue: 0xff/255, alpha: 100)
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var loadingCog: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpBubble: UIImageView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var twoPlayerTopImage: UIImageView!
    @IBOutlet weak var twoPlayerBotImage: UIImageView!
    @IBOutlet weak var biggerHelpBubble: UIImageView!
    

    @IBAction func next(_ sender: Any) {
        //didStartMainActivity(self.setupManager)
        
    }
    @IBAction func helpButtonTapped(_ sender: Any) {
        if (!inProgress) {
            UIView.animate(withDuration: 0.5, animations: {
                self.biggerHelpBubble.alpha=1.0
                self.twoPlayerTopImage.alpha=1.0
                self.twoPlayerBotImage.alpha=1.0
            }, completion: {
                (finished) in
                UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                    self.twoPlayerTopImage.center.y = self.twoPlayerTopImage.center.y+20
                    self.twoPlayerBotImage.center.y = self.twoPlayerBotImage.center.y-20
                }, completion: {
                    (finished) in
                    UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                        self.twoPlayerTopImage.alpha=0.0
                        self.twoPlayerBotImage.alpha=0.0
                        self.biggerHelpBubble.alpha=0.0
                        self.twoPlayerTopImage.center.y-=20
                        self.twoPlayerBotImage.center.y+=20
                    })})
            })

        }else{
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
        switch self.team {
        case 1:
            loadingCog.image = UIImage(named: "cogTeam1")
        case 2:
            loadingCog.image = UIImage(named: "cogTeam2")
        case 3:
            loadingCog.image = UIImage(named: "cogTeam3")
        case 4:
            loadingCog.image = UIImage(named: "cogTeam4")
        default:
            break
        }
        
        super.viewDidLoad()
        self.debugMode = true
       
        setupStartView()
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.goToTeamSelection()
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
        self.inProgress=inProgress
        setView(position: position, mode: mode, inProgress: inProgress)
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
        helpBubble.alpha = 0
        helpLabel.alpha = 0
        biggerHelpBubble.alpha=0
        twoPlayerBotImage.alpha=0
        twoPlayerTopImage.alpha=0
        twoPlayerBotImage.transform = CGAffineTransform(rotationAngle: .pi)
        helpButton.center.y=view.bounds.height-125
        helpButton.center.x=view.bounds.width-125
        biggerHelpBubble.center.x = helpButton.center.x - biggerHelpBubble.bounds.width/2 - helpButton.bounds.width/2+50
        biggerHelpBubble.center.y = view.bounds.height - biggerHelpBubble.bounds.height/2 - 50
        twoPlayerTopImage.center.x=biggerHelpBubble.center.x
        twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-10
        twoPlayerBotImage.center.x=biggerHelpBubble.center.x
        twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+10
        
        stateLabel.text = connectingString
        /*if !debugMode {
            

            
        }*/
        shortBorder.isHidden=true
        longBorder.isHidden=true
        self.navigationController?.isNavigationBarHidden = true
        stateLabel.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 2.0, animations: {
            self.stateLabel.center.y = self.view.bounds.height/2
            self.stateLabel.center.x = self.view.bounds.width/2 - 160
            self.loadingCog.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.loadingCog.center.y = self.view.bounds.height/2
            self.loadingCog.center.x = self.view.bounds.width/2 + 160
            self.backButton.center.y = self.view.bounds.height-75
            self.backButton.center.x = self.view.bounds.width/2
            self.backButton.alpha=60
        })
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.loadingCog.transform = CGAffineTransform(rotationAngle: (.pi))
        })
  
    }
    private func setView(position : DevicePosition, mode : GameMode, inProgress: Bool) {
        if(!inProgress){
            loadingCog.transform = CGAffineTransform.identity
            stateLabel.transform = CGAffineTransform.identity
        switch position {
        case DevicePosition.one:
            if(mode == GameMode.twoplayer){
                UIView.animate(withDuration: 2.0, animations: {
                    self.loadingCog.center.y=0
                    self.loadingCog.center.x=self.view.bounds.width/2
                    self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.stateLabel.center.x = self.view.bounds.width/2
                    self.stateLabel.center.y = self.view.bounds.height/2 + 100
                })
            }
            else{
                self.longBorder.backgroundColor = self.oneTwo
                self.shortBorder.backgroundColor = self.oneFour
               oddPositionSetup()
            }
        case DevicePosition.two:
            stateLabel.transform = CGAffineTransform(rotationAngle: .pi)
            helpButton.transform = CGAffineTransform(rotationAngle: .pi)
            biggerHelpBubble.transform = CGAffineTransform(rotationAngle: .pi)
            biggerHelpBubble.center.x = biggerHelpBubble.bounds.width/2 + 175
            biggerHelpBubble.center.y = biggerHelpBubble.bounds.height/2 + 50
            twoPlayerTopImage.center.x=biggerHelpBubble.center.x
            twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-10
            twoPlayerBotImage.center.x=biggerHelpBubble.center.x
            twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+10
            helpButton.isHidden=true
            helpButton.center.y=125
            helpButton.center.x=125
            if(mode == GameMode.twoplayer){
                UIView.animate(withDuration: 2.0, animations: {
                    self.loadingCog.center.y=self.view.bounds.height
                    self.loadingCog.center.x=self.view.bounds.width/2
                    self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
                    self.stateLabel.isHidden=true
                    self.backButton.isHidden=true
                }, completion: { (finished) in
                    self.backButton.center.y = 75
                    self.backButton.center.x = self.view.bounds.width/2
                    self.stateLabel.center.x = self.view.bounds.width/2
                    self.stateLabel.center.y = self.view.bounds.height/2 - 100
                    self.backButton.isHidden=false
                    self.stateLabel.isHidden=false
                    self.helpButton.isHidden=false
                })
            }
            else{
                self.longBorder.backgroundColor = self.oneTwo
                self.shortBorder.backgroundColor = self.twoThree
               evenPositionSetup()
            }
        case DevicePosition.three:
            self.longBorder.backgroundColor = self.threeFour
            self.shortBorder.backgroundColor = self.twoThree
           oddPositionSetup()
        case DevicePosition.four:
            stateLabel.transform = CGAffineTransform(rotationAngle: .pi)
            helpButton.transform = CGAffineTransform(rotationAngle: .pi)
            biggerHelpBubble.transform = CGAffineTransform(rotationAngle: .pi)
            biggerHelpBubble.center.x = biggerHelpBubble.bounds.width/2 + 175
            biggerHelpBubble.center.y = biggerHelpBubble.bounds.height/2 + 50
            twoPlayerTopImage.center.x=biggerHelpBubble.center.x
            twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-10
            twoPlayerBotImage.center.x=biggerHelpBubble.center.x
            twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+10
            helpButton.isHidden=true
            helpButton.center.y=125
            helpButton.center.x=125
            self.longBorder.backgroundColor = self.threeFour
            self.shortBorder.backgroundColor = self.oneFour
            evenPositionSetup()
        default:
            break
        }
        }else {setupStartView() }
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
    
    private func oddPositionSetup(){
        self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: 0, height: 50)
        self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: 0)
        UIView.animate(withDuration: 2.0, animations: {
            self.loadingCog.center.y=0
            self.loadingCog.center.x=self.view.bounds.width
            self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: -self.view.bounds.width, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: self.view.bounds.height)
            //self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: 50)
        })
    }
    
    private func evenPositionSetup(){
        self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: 0, height: 50)
        self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: 0)
        UIView.animate(withDuration: 2.0, animations: {
            self.loadingCog.center.y=self.view.bounds.height
            self.loadingCog.center.x=self.view.bounds.width
            self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
            //self.longBorder.center.y = self.view.bounds.height-25
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: -self.view.bounds.width, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: -self.view.bounds.height)
        }, completion: { (finished) in
            self.backButton.center.y = 75
            self.backButton.center.x = self.view.bounds.width/2
            self.stateLabel.center.x = self.view.bounds.width/2
            self.stateLabel.center.y = self.view.bounds.height/2 - 100
            self.backButton.isHidden=false
            self.stateLabel.isHidden=false
            self.helpButton.isHidden=false
        })
    }
    
    
}
