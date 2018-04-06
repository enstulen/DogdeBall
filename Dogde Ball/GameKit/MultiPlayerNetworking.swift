//
//  MultiPlayerNetworking.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 12.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import GameKit

protocol MultiplayerNetworkingProtocol: class {
    func matchEnded()
}

class MultiPlayerNetworking: NSObject, GameKitHelperDelegate {
    weak var delegate: MultiplayerNetworkingProtocol?

    func matchStarted() {
        print("match started")
    }
    
    func matchEnded() {
        print("match ended")
        
    }
    
    func match(match: GKMatch, didReceive data: Data, fromPlayer playerID: String) {
        print("recived data")
        
    }
}
