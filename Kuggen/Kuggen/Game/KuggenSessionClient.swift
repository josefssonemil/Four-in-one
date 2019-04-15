//
//  KuggenSessionClient.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity

// Subclassing the SessionManager with client-specific behavior

class KuggenSessionClient : KuggenSessionManager {
    
    
    override func readyForNextLevel() {
        handleLocal(event: makeHoldingEvent(on: true))
    }
    
    override func cancelReadyForNextLevel() {
        handleLocal(event: makeHoldingEvent(on: false))
    }
    
    override func startNextLevel() {
        super.startNextLevel()
        
        OperationQueue.main.addOperation {
            
            self.kuggenDelegate?.gameManagerNextLevel(self)
        }
    }
    
    
    override public func handleLocal(event: FourInOneEvent, from sender: AnyObject? = nil) {
        sendEventToServer(event)
    }
    
    
    
    override public func clientHandleRemote(event: FourInOneEvent, from server:MCPeerID) {
        
        if event.type == moveEvent {
            
        }
            
        else if event.type == cogRotationEvent{
        }
        
        else if event.type == moveOnlyEvent {
            
        }
        
        else if event.type == levelEvent {
            handleRemoteLevelEvent(event)
        }
        
        else if event.type == endLevelEvent {
            handleRemoteEndLevelEvent(event)
            
        }
        
        else if event.type == nextLevelEvent {
            startNextLevel()
        }
        
    
    }
    
    private func handleRemoteLevelEvent(_ event:FourInOneEvent) {
        
        if let countString = event.info[intKey], let count = Int(countString) {
            
            levelCount = count
        }
        
        if let levelString = event.info[levelKey] {
            
            let localLevel = LevelReader.createLevel(nameOfLevel: "level1")
            
            /*OperationQueue.main.addOperation {
                self.kuggenDelegate?.gameManager(self, newLevel: localLevel)
            }*/
        }
        
    }
    
    private func handleRemoteEndLevelEvent(_ event:FourInOneEvent) {
        
        if let scoreString = event.info[scoreKey] {
            
            if let score = Int(scoreString) {
                self.score = score
                
                OperationQueue.main.addOperation {
                    
                    self.kuggenDelegate?.gameManager(self, endedLevel: nil, success: score > 0)
        
                }
            }
            
            else {
                print("error decoding score event")
            }
            
        }
        
    }
}

