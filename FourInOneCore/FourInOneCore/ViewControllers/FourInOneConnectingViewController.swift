//
//  FourInOneConnectingViewController.swift
//  FourInOneCore
//
//  Created by Olof Torgersson on 2017-11-24.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import UIKit
import MultipeerConnectivity

/**
 The `FourInOneConnectingViewController`class implements the basic behaviour of a
 view controller involved in a 4-in-1 set up session. It implements the methods of the `FourInOneSetupManagerDelegate` protocol and can show information the provides detail about the set up process that can be useful during development and debugging. To create a connecting view controller for a specific application it is necessary to create a subclass that implements the method `updateView(position:, mode:, inProgress:)` to describe what should happen in the view managed by the connecting view controller.
 
 The view controller has four outlets for showing status data. Whether the view controller shows this data or not is controlled by the value of the property ``debugMode``.
 */
open class FourInOneConnectingViewController: FourInOneViewController, FourInOneSetupManagerDelegate {
    
    // MARK: - Properties

    /// Used for showing the current team and position.
    @IBOutlet weak public var teamLabel: UILabel!
    
    /// The display name of the peer id of this device.
    @IBOutlet weak public var idLabel: UILabel!
    
    /// Used to show the name of the current server
    @IBOutlet weak public var serverLabel: UILabel!
    
    /// Used to show the display name of all connected peers.
    @IBOutlet weak public var peersLabel: UILabel!
    
    /// Identifies the current team.
    public var team = 0
    
    /// The `FourInOneSetupManager`handling the session set up.
    public var setupManager : FourInOneSetupManager!
    
    /// Whether the view controller shows debug information or not.
    public var debugMode = false
    
    /// The story board segue to use to load the view to show aftre the set up process.
    public var showMainViewSegue : String = "showMainViewSegue"
    
    // MARK: - View loading and appearance

    /// Initializes the set up manager used.
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSessionManager()
        
    }
    
    /// Sets this this view controller to be the delegate of the set up manager and tells it to start the session.
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupManager.delegate = self
        setupManager.startSetup()
        
    }
    
    // MARK: - Session stoppas inte nu när man backar?
    
    /// Stops the ongoing set up process and sets the set up manager's delegate to nil.
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // print("viewDidDisappear")
        
        setupManager.delegate = nil
        setupManager.stopSetup()
        
    }
    
    /// Called when the set up manager signals that set up is done and that it is time
    /// to start the main activity. The default implementation calls self to perform the segue
    /// defined by `showMainViewSegue`.
    open func didStartMainActivity(_ manager: FourInOneSetupManager) {
        
        self.performSegue(withIdentifier: showMainViewSegue, sender: self)
        
    }
    
    // MARK: - Updating the view

    /// Called to update the view when the status of the set up process changes.
    /// The default implementation is empty. Note that since a session can consist of 2 or 4 devices
    /// the set up is considered to be done when the number och devices in the session is 2 or 4.
    /// - parameter position: The position of this device.
    /// - parameter mode: TThe current mode, i.e., the number of participating devices.
    /// - parameter position: The position of this device.
    /// - parameter inProgress: Whether the set up is going on or not.
    open func updateView(position: DevicePosition, mode: GameMode, inProgress: Bool) {
        
    }
    

    // MARK: - Debugging

    /// Different kinds of debug information.
    public enum DebugInfo {
        
        case starting, didstart, serverchanged, positionchanged, deviceschanged, didcomplete
        
    }
    
    /// Shows debug information if the view controller is in debug mode.
    /// This method is called as a result of feedback from the underlying set up manager.
    public func showDebugInfo(type:DebugInfo, peer:MCPeerID? = nil, position:DevicePosition? = nil, devices:[String]? = nil) {
        
        if debugMode {
            
            switch type {
                
            case .starting:
                
                self.teamLabel.text = self.positionString(team: self.team, position: .one)
                
            case .didstart:
                
                self.idLabel.text = "Id: \(self.setupManager.myPeerId.displayName)"
                
            case .serverchanged:
                
                let name = peer!.displayName
                let message = "Server: \(name)"
                
                self.idLabel.text = "Id: \(self.setupManager.myPeerId.displayName)"
                self.serverLabel.text = message
                
            case .positionchanged:
                
                self.teamLabel.text = self.positionString(team: self.team, position: position!)
                
            case .deviceschanged:
                
                if  let names = devices {
                    
                    let message = "Peers: \(names)"
                    self.peersLabel.text = message
                    
                }
                
            case .didcomplete:
                
                if let manager = self.setupManager {
                    
                    self.idLabel.text = "Id: \(manager.myPeerId.displayName)"
                    self.serverLabel.text = "Server: \(manager.server.displayName)"
                    self.teamLabel.text = self.positionString(team: self.team, position:manager.position)
                    
                }
                
            }
        }
    }
    
    private func positionString(team: Int, position: DevicePosition) -> String {
        
        switch position {
        case .one:
            return "\(team):A"
        case .two:
            return "\(team):B"
        case .three:
            return "\(team):C"
        case .four:
            return "\(team):D"
            
        }
    }
    
    private func setupSessionManager() {
        
        setupManager = FourInOneSetupManager()
        setupManager.serviceType = "\(FourInOneService)\(team)"
        
        // print("serviceType: \(setupManager.serviceType)")
        
    }
    
    // MARK: - FourInOneSetupManagerDelegate
    
    /// The default method does nothing but calls `showDebugInfo(type:)`.
    open func setupManagerDidStartSession(_ manager: FourInOneSetupManager) {
        
        showDebugInfo(type: .didstart)
        
    }
    
    /// The default implementation does nothing.
    open func setupManagerDidCancel(_ manager: FourInOneSetupManager) {
        
    }
    
    /// The default implementation shows debug information and calls
    /// `updateView(position:, mode:, inProgress:)`
    open func setupManagerDidComplete(_ manager: FourInOneSetupManager) {
        
        self.showDebugInfo(type: .didcomplete)
        self.updateView(position: manager.position, mode: manager.gameMode, inProgress: false)
        
    }
    
    /// The default implementation does nothing.
    open func setupManagerDidRejectInvite(_ manager: FourInOneSetupManager) {
        
    }
    
    /// The default implementation calls
    /// `updateView(position:mode:inProgress:)`.
    open func setupManager(_ manager: FourInOneSetupManager, lostPeer peer: MCPeerID, inMode mode: GameMode) {
        
        self.updateView(position: manager.position, mode: manager.gameMode, inProgress: true)
        
    }
    
    /// The default implementation calls
    /// `updateView(position:mode:inProgress:)`.
    open func setUpManager(_ manager: FourInOneSetupManager, foundThirdPeer peer: MCPeerID) {
        
        self.updateView(position: manager.position, mode: .fourplayer, inProgress: true)
        
    }
    
    /// The default implementation shows debug information and calls
    /// `updateView(position:, mode:, inProgress:)`
    open func setUpManager(_ manager: FourInOneSetupManager, didChangePosition position: DevicePosition, withMode mode: GameMode) {
        
        self.showDebugInfo(type: .positionchanged, peer: nil, position: position)
        self.updateView(position: position, mode: mode, inProgress: true)
        
    }
    
    /// The default method does nothing but calls `showDebugInfo(type:)`.
    open func setupManager(_ manager: FourInOneSetupManager, didChangeServerToPeer peer: MCPeerID) {
        
        self.showDebugInfo(type: .serverchanged, peer: peer)
        
    }
    
    /// The default method does nothing but calls `showDebugInfo(type:)`.
    open func setUpManager(_ manager: FourInOneSetupManager, connectedDevicesDidChange devices: [String]) {
        
        self.showDebugInfo(type: .deviceschanged, devices: devices)
        
    }
    
    /// The default implementation calls `didStartMainActivity`.
    open func setupManagerDidStartGame(_ manager: FourInOneSetupManager) {
        
        self.didStartMainActivity(manager)
        
    }
    
    
}
