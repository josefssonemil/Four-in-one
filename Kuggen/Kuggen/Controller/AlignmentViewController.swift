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
    private var mode = GameMode.twoplayer
    
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
    @IBOutlet weak var fourPlayerTopImage: UIImageView!
    @IBOutlet weak var fourPlayerBotImage: UIImageView!
    @IBOutlet weak var biggerHelpBubble: UIImageView!
    @IBOutlet weak var handOne: UIImageView!
    @IBOutlet weak var handTwo: UIImageView!
    @IBOutlet weak var handThree: UIImageView!
    @IBOutlet weak var handFour: UIImageView!
    
    

    @IBAction func next(_ sender: Any) {
        //didStartMainActivity(self.setupManager)
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        if (!inProgress) {
            handOne.image = UIImage(named: "handFlipped")
            handTwo.image = UIImage(named: "hand")
            handThree.image = UIImage(named: "handFlipped")
            handFour.image = UIImage(named: "hand")
            handOne.center.x=twoPlayerBotImage.center.x
            handOne.center.y=twoPlayerBotImage.center.y+35
            handTwo.center.x=twoPlayerTopImage.center.x
            handTwo.center.y=twoPlayerTopImage.center.y-35
            handThree.center.x=fourPlayerTopImage.center.x
            handThree.center.y=fourPlayerTopImage.center.y-35
            handFour.center.x=fourPlayerBotImage.center.x
            handFour.center.y=fourPlayerBotImage.center.y+35
            if(mode==GameMode.fourplayer){
                twoPlayerBotImage.image = UIImage(named: "4playerHelpOdd")
                twoPlayerTopImage.image = UIImage(named: "4playerHelpEven")
                UIView.animate(withDuration: 0.5, animations: {
                    self.biggerHelpBubble.alpha=1.0
                    self.twoPlayerTopImage.alpha=1.0
                    self.twoPlayerBotImage.alpha=1.0
                    self.fourPlayerTopImage.alpha=1.0
                    self.fourPlayerBotImage.alpha=1.0
                }, completion: {
                    (finished) in
                    UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                        self.twoPlayerTopImage.center.y += 20
                        self.twoPlayerBotImage.center.y -= 20
                        self.fourPlayerTopImage.center.y += 20
                        self.fourPlayerBotImage.center.y -= 20
                        self.twoPlayerTopImage.center.x += 20
                        self.twoPlayerBotImage.center.x += 20
                        self.fourPlayerTopImage.center.x -= 20
                        self.fourPlayerBotImage.center.x -= 20
                    }, completion: {
                        (finished) in
                        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                            self.handOne.alpha=1
                            self.handTwo.alpha=1
                            self.handThree.alpha=1
                            self.handFour.alpha=1
                        }, completion: {
                            (finished) in
                            UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                                self.handOne.image = UIImage.init(named: "handClickedFlipped")
                                self.handTwo.image = UIImage.init(named: "handClicked")
                                self.handThree.image = UIImage.init(named: "handClickedFlipped")
                                self.handFour.image = UIImage.init(named: "handClicked")
                            }, completion: {
                        (finished) in
                        UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                            self.handOne.alpha=0
                            self.handTwo.alpha=0
                            self.handThree.alpha=0
                            self.handFour.alpha=0
                            self.twoPlayerTopImage.alpha=0.0
                            self.twoPlayerBotImage.alpha=0.0
                            self.fourPlayerTopImage.alpha=0.0
                            self.fourPlayerBotImage.alpha=0.0
                            self.biggerHelpBubble.alpha=0.0
                            self.twoPlayerTopImage.center.y-=20
                            self.twoPlayerBotImage.center.y+=20
                            self.twoPlayerTopImage.center.x-=20
                            self.twoPlayerBotImage.center.x-=20
                            self.fourPlayerTopImage.center.y-=20
                            self.fourPlayerBotImage.center.y+=20
                            self.fourPlayerTopImage.center.x+=20
                            self.fourPlayerBotImage.center.x+=20
                        })})})})
                })
                
            }
            else if(mode==GameMode.twoplayer){
                twoPlayerBotImage.image = UIImage(named: "2playerhelp")
                twoPlayerTopImage.image = UIImage(named: "2playerhelp")
                UIView.animate(withDuration: 0.5, animations: {
                    self.biggerHelpBubble.alpha=1.0
                    self.twoPlayerTopImage.alpha=1.0
                    self.twoPlayerBotImage.alpha=1.0
                }, completion: {
                    (finished) in
                    UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                        self.twoPlayerTopImage.center.y += 20
                        self.twoPlayerBotImage.center.y -= 20
                    }, completion: {
                        (finished) in
                        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                            self.handOne.alpha=1
                            self.handTwo.alpha=1
                        }, completion: {
                            (finished) in
                            UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
                                self.handOne.image = UIImage.init(named: "handClickedFlipped")
                                self.handTwo.image = UIImage.init(named: "handClicked")
                            }, completion: {
                        (finished) in
                        UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                            self.handOne.alpha=0
                            self.handTwo.alpha=0
                            self.twoPlayerTopImage.alpha=0.0
                            self.twoPlayerBotImage.alpha=0.0
                            self.biggerHelpBubble.alpha=0.0
                            self.twoPlayerTopImage.center.y-=20
                            self.twoPlayerBotImage.center.y+=20
                        })})})})
                })
            }
        }

        else{
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
        self.helpButton.setImage(UIImage(named: "robotBlink"), for: .highlighted)
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
        twoPlayerBotImage.transform = CGAffineTransform(rotationAngle: .pi)
        fourPlayerBotImage.transform = CGAffineTransform(rotationAngle: .pi)
        handTwo.transform = CGAffineTransform(rotationAngle: .pi)
        handThree.transform = CGAffineTransform(rotationAngle: .pi)
        self.debugMode = true
       
        setupStartView()
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        setupManager.cancelSetup()
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
        self.mode=mode
        if(!inProgress){
        setViewToPosition(position: position, mode: mode)
            } else { resetView()}

        stateLabel.text = (inProgress ? connectingString : connectedString)
            }
    
    private func setupStartView() {
        //Sets all attributes that should not be visible at start to invisible
        helpBubble.alpha = 0
        helpLabel.alpha = 0
        biggerHelpBubble.alpha=0
        twoPlayerBotImage.alpha=0
        twoPlayerTopImage.alpha=0
        fourPlayerTopImage.alpha=0
        fourPlayerBotImage.alpha=0
        handOne.alpha=0
        handTwo.alpha=0
        handThree.alpha=0
        handFour.alpha=0
        
        showDebugInfo(type: .starting)
        teamLabel.isHidden = true
        idLabel.isHidden = true
        serverLabel.isHidden = true
        peersLabel.isHidden = true
        resetView()
        /*if !debugMode {
            

            
        }*/
 
  
    }
    
    private func resetView(){
        
        //placement of the helper robot
        helpButton.transform = CGAffineTransform.identity
        helpButton.center.y=view.bounds.height-125
        helpButton.center.x=view.bounds.width-125
        biggerHelpBubble.center.x = helpButton.center.x - biggerHelpBubble.bounds.width/2 - helpButton.bounds.width/2+50
        biggerHelpBubble.center.y = view.bounds.height - biggerHelpBubble.bounds.height/2 - 50
        twoPlayerTopImage.center.x=biggerHelpBubble.center.x
        twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-10
        twoPlayerBotImage.center.x=biggerHelpBubble.center.x
        twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+10
        
        stateLabel.text = connectingString
        //shortBorder.isHidden=true
        //longBorder.isHidden=true
        self.navigationController?.isNavigationBarHidden = true
        stateLabel.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 2.0, animations: {
            self.longBorder.alpha = 0
            self.shortBorder.alpha = 0
            self.stateLabel.center.y = self.view.bounds.height/2
            self.stateLabel.center.x = self.view.bounds.width/2 - 160
            self.loadingCog.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.loadingCog.center.y = self.view.bounds.height/2
            self.loadingCog.center.x = self.view.bounds.width/2 + 160
            self.backButton.center.y = self.view.bounds.height-75
            self.backButton.center.x = self.view.bounds.width/2
        })
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.loadingCog.transform = CGAffineTransform(rotationAngle: (.pi))
        })
    }
    private func setViewToPosition(position : DevicePosition, mode : GameMode) {
            loadingCog.transform = CGAffineTransform.identity
            stateLabel.transform = CGAffineTransform.identity
            switch position {
            case DevicePosition.one:
                if(mode == GameMode.twoplayer){
                    oddPositionSetup(positionOfCogX: self.view.bounds.width/2, positionOfCogY: 0)
                    twoPlayerSetup()
                }
                else{
                    self.longBorder.backgroundColor = self.oneTwo
                    self.shortBorder.backgroundColor = self.oneFour
                    oddPositionSetup(positionOfCogX: view.bounds.width, positionOfCogY: 0)
                    fourPlayerSetup()
                }
            case DevicePosition.two:
                if(mode == GameMode.twoplayer){
                    evenPositionSetup(positionOfCogX: view.bounds.width/2, positionOfCogY: view.bounds.height)
                    twoPlayerSetup()
                }
                else{
                    self.longBorder.backgroundColor = self.oneTwo
                    self.shortBorder.backgroundColor = self.twoThree
                    evenPositionSetup(positionOfCogX: view.bounds.width, positionOfCogY: view.bounds.height)
                    fourPlayerSetup()
                }
            
            case DevicePosition.three:
                self.longBorder.backgroundColor = self.threeFour
                self.shortBorder.backgroundColor = self.twoThree
                oddPositionSetup(positionOfCogX: view.bounds.width, positionOfCogY: 0)
                fourPlayerSetup()
            
            case DevicePosition.four:
                evenPositionSetup(positionOfCogX: view.bounds.width, positionOfCogY: view.bounds.height)
                fourPlayerSetup()
                self.longBorder.backgroundColor = self.threeFour
                self.shortBorder.backgroundColor = self.oneFour
            default:
                break
            }
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
    
    private func twoPlayerSetup(){
        //settings for where the help images should be aligned in the speechbubble from the help robot
        twoPlayerTopImage.center.x=biggerHelpBubble.center.x
        twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-7.5
        twoPlayerBotImage.center.x=biggerHelpBubble.center.x
        twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+7.5
    }
    
    private func fourPlayerSetup(){
        longBorder.alpha=1
        shortBorder.alpha=1
        //settings for where the help images should be aligned in the speechbubble from the help robot
        twoPlayerTopImage.center.x=biggerHelpBubble.center.x - twoPlayerTopImage.bounds.width/2 - 5
        twoPlayerTopImage.center.y=(biggerHelpBubble.center.y-(twoPlayerTopImage.bounds.height/2))-7.5
        twoPlayerBotImage.center.x=biggerHelpBubble.center.x - twoPlayerBotImage.bounds.width/2 - 5
        twoPlayerBotImage.center.y=(biggerHelpBubble.center.y+(twoPlayerBotImage.bounds.height/2))+7.5
        fourPlayerTopImage.center.x=biggerHelpBubble.center.x + fourPlayerTopImage.bounds.width/2 + 5
        fourPlayerTopImage.center.y=(biggerHelpBubble.center.y-(fourPlayerTopImage.bounds.height/2))-7.5
        fourPlayerBotImage.center.x=biggerHelpBubble.center.x + fourPlayerBotImage.bounds.width/2 + 5
        fourPlayerBotImage.center.y=(biggerHelpBubble.center.y+(fourPlayerBotImage.bounds.height/2))+7.5
    }
    
    private func oddPositionSetup(positionOfCogX: CGFloat, positionOfCogY: CGFloat){
        loadingCog.transform = CGAffineTransform.identity
        self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: 0, height: 50)
        self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: 0)
        self.helpButton.isHidden = true
        self.helpButton.center.x = 125
        helpButton.transform = CGAffineTransform(rotationAngle: .pi/2)
        stateLabel.isHidden=true
        stateLabel.center.x = view.bounds.width/2
        stateLabel.center.y = view.bounds.height/2 + 100
        //animations
        UIView.animate(withDuration: 2.0, animations: {
            self.loadingCog.center.y=positionOfCogY
            self.loadingCog.center.x=positionOfCogX
            self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: 0, width: -self.view.bounds.width, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: 0, width: 50, height: self.view.bounds.height)
        }, completion: { (finished) in
            self.stateLabel.isHidden=false
            self.helpButton.isHidden = false
        })
    }
    
    private func evenPositionSetup(positionOfCogX: CGFloat, positionOfCogY: CGFloat){
        loadingCog.transform = CGAffineTransform.identity
        //Settings for the state label
        stateLabel.isHidden=true
        stateLabel.transform = CGAffineTransform(rotationAngle: .pi)
        self.stateLabel.center.x = self.view.bounds.width/2
        self.stateLabel.center.y = self.view.bounds.height/2 - 100
        
        //Settings for the help button
        helpButton.transform = CGAffineTransform(rotationAngle: .pi)
        biggerHelpBubble.transform = CGAffineTransform(rotationAngle: .pi)
        biggerHelpBubble.center.x = biggerHelpBubble.bounds.width/2 + 175
        biggerHelpBubble.center.y = biggerHelpBubble.bounds.height/2 + 50
        helpButton.isHidden=true
        helpButton.center.y=125
        helpButton.center.x=125
        
        //Settings for the backButton
        backButton.isHidden=true
        backButton.center.y = 75
        backButton.center.x = self.view.bounds.width/2
        
        //Settings for the alignment borders
        self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: 0, height: 50)
        self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: 0)
        
        //animations
        UIView.animate(withDuration: 2.0, animations: {
            self.loadingCog.center.y=positionOfCogY
            self.loadingCog.center.x=positionOfCogX
            self.loadingCog.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.longBorder.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height-50, width: -self.view.bounds.width, height: 50)
            self.shortBorder.frame = CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height, width: 50, height: -self.view.bounds.height)
        }, completion: { (finished) in
            self.backButton.isHidden=false
            self.stateLabel.isHidden=false
            self.helpButton.isHidden=false
        })
    }
    
    
}
