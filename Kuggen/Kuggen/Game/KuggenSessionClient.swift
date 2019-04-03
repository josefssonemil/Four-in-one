//
//  KuggenSessionClient.swift
//  Kuggen
//

import UIKit
import FourInOneCore
import MultipeerConnectivity

// Subclassing the SessionManager with client-specific behavior

class KuggenSessionClient : KuggenSessionManager {
    
    
    
    
    override public func handleLocal(event: FourInOneEvent, from sender: AnyObject? = nil) {
        sendEventToServer(event)
    }
    
    override public func clientHandleRemote(event: FourInOneEvent, from server:MCPeerID) {
    
        
    }
}

