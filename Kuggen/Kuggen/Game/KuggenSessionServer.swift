//
//  KuggenSessionServer.swift
//  Kuggen
//
//  Created by Emil Josefsson on 2019-03-12.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit
import FourInOneCore
import MultipeerConnectivity


// Subclassing the SessionManager with server-specific behavior

class KuggenSessionServer: KuggenSessionManager {
    
    // List of levels
    private var levels : [Level]
    
    // variable for holding
    var isHolding = false
    
    override init() {
        levels = []
        super.init()
        
        //levels = LevelManager.sharedInstance.levels
        
        levelCount = levels.count
    }
    
    func readyToPlay(bool: Bool){
        sendEventToClients(makeReadyToPlayEvent(bool: bool))
    }
    
    // Moving on to the next level
    override func readyForNextLevel() {
        isHolding = true
        
        // if all is holding start the next level
        if allHolding() {
            startNextLevel()
        }
        
    }
    
    override func cancelReadyForNextLevel() {
        
        isHolding = false
        
    }
    
    // start the next level
    override func startNextLevel() {
        super.startNextLevel()


        sendEventToClients(makeNextLevelEvent())
        
        OperationQueue.main.addOperation {
            self.kuggenDelegate?.gameManagerNextLevel(self)
        }
        
    }
    
    private func handleHolding(down:Bool, from peer:MCPeerID) {
        
        for index in 0..<clients.count {
            
            if clients[index].peer.displayName == peer.displayName {
                clients[index].holding = down
            }
        }
        
        if allHolding() {
            startNextLevel()
        }
        
    }
    
    private func allHolding() -> Bool {
        
        if !isHolding {
            
            return false
            
        }
        
        for client in clients {
            
            if !client.holding {
                return false
            }
        }
        return true
        
    }
    // End level
    private func endLevel(success:Bool) {
        
        self.score = levelScore(success: success)
        
        let endLevelEvent = makeEndLevelEvent(score: self.score)
        
        self.sendDataMode = .reliable
        sendEventToClients(endLevelEvent)
        self.sendDataMode = .unreliable
        
        OperationQueue.main.addOperation {
            self.kuggenDelegate?.gameManager(self, endedLevel: nil, success:self.score > 0)
        }
    }
    
    private func levelScore(success:Bool) -> Int {
        
        if success {
            return 1
        }
        else {
            return 0
        }
        
    }
    
    override func synchronizeRotation(impulse: CGFloat, cogName: String) {
    /* Create the rotate event containing impulse and specified cogwheel */
    
        let rotation = makeCogRotation(impulse: impulse, cogName: cogName)
    
    
        print("server sync rotation")
        //handleLocal(event: rotation)
        /* Sending the rotate event to clients */
        sendEventToClients(rotation)
        
        OperationQueue.main.addOperation {
            self.kuggenDelegate?.gameManager(self, impulse: impulse, cogName: cogName)
        }
    
    }
    
    
    
    
    override public func handleLocal(event: FourInOneEvent, from sender: AnyObject? = nil) {
        
        sendEventToClients(event)
        
    }
    override public func serverHandleRemote(event: FourInOneEvent, from client:MCPeerID) {
        let type = event.type
        
        if type == cogRotationEvent {
            
            /* Unwrap event info*/
            let impulseString = event.info[impulseKey]
            let cogName = event.info[nameKey]
            
            /* Transform the string back to a float */
            let impulse = CGFloat((impulseString! as NSString).floatValue)
            let exclude = event.info[peerKey]
            
            let excludeID = MCPeerID(displayName: exclude!)
            sendEventToClients(event, exluding: excludeID)
            
       
            OperationQueue.main.addOperation {
                self.kuggenDelegate?.gameManager(self, impulse: impulse, cogName: cogName!)
            }

        }
        
    }
    
    private func handleRemoteHoldingEvent(_ event:FourInOneEvent, client:MCPeerID) {
        
        if let holdingString = event.info[boolKey], let isHolding = Bool(holdingString) {
            
            handleHolding(down: isHolding, from: client)
        }
    }
}
