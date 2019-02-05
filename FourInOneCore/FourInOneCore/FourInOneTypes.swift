//
//  FourInOneTypes.swift
//  4in1Setup
//
//  Created by Olof Torgersson on 2017-10-06.
//  Copyright © 2017 Olof Torgersson. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public let FourInOneService = "idac-team"

/**
 
 Indicates the position of the current device in the virtual board resulting from starting a 4-in-1 session.
 A session with two devices makes use of postion one and two.
 
 */
public enum DevicePosition : Int {
    
    case one=1, two=2, three=3, four=4
    
}

/**
 
 Indicates the mode of a 4-in-1 session. Currently a session can consist of either 1, 2 or 4 devices.
 The single device mode can be used to indicate e.g., training sessions with a single device only.
 
 */
public enum GameMode : Int {
    
    case singleplayer = 1,
    twoplayer = 2,
    fourplayer = 4
    
}

/**
 
 Used to indicate which framework is used to build the user interface of a 4-in-1 session.
 
 */
public enum Platform {
    case uikit
    case spritekit
}

/**
 
 A FourInOneEvent represents an event in a 4-in-1 session and is used to send information between devices. No assumptions are made about the contents of an event but the idea is that the type member indicates what the event is about while the info member contains further information. Users of the framework need to decide upon what the contents of events are and how to handle them.
 
 */
public struct FourInOneEvent : Codable {
    
    public var type : String
    public var info : [String : String]
    
    /** Creates an event where type is the empty string and info an empty dictionary */
    public init() {
        
        self.init(type: "", info: [:])
        
    }
    
    public init(type:String, info:[String : String]) {
        
        self.type = type
        self.info = info
        
    }
}

/**
 
 A PeerInfo structure contains additional information about a peer in a sessions. It is mainly used internally by the framework to keep track of the members in a session.
 
 */
public struct PeerInfo {
    
    public var peer : MCPeerID
    public var holding : Bool
    public var connected : Bool
    public var position: DevicePosition
    
    public init(peer:MCPeerID) {
        
        self.peer = peer
        holding = false
        connected = false
        position = .one
        
    }
    
    public init(peer:MCPeerID, connected:Bool) {
        
        self.peer = peer
        holding = false
        self.connected = connected
        position = .one
        
    }
    
    public init(peer:MCPeerID, position:DevicePosition) {
        
        self.peer = peer
        holding = false
        connected = false
        self.position = position
        
    }
    
    public init(peer:MCPeerID, connected:Bool, position:DevicePosition) {
        
        self.peer = peer
        holding = false
        self.connected = connected
        self.position = position
        
    }
    
    public init() {
        
        peer = MCPeerID()
        holding = false
        connected = false
        position = .one
        
    }
    
}


extension PeerInfo: Equatable {
    
    /** Two PeerInfo structures are considered to be equal if their peer members have the same display name */
    public static func == (lhs: PeerInfo, rhs: PeerInfo) -> Bool {
        return
            lhs.peer.displayName == rhs.peer.displayName
    }
}
