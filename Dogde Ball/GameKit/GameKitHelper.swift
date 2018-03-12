//
//  GameKitHelper.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 12.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import GameKit

protocol GameKitHelperDelegate: class {
    func matchStarted()
    func matchEnded()
    func match(match: GKMatch, didReceive data: Data, fromPlayer playerID: String)
}

class GameKitHelper: NSObject, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    
    var authenticationViewController: UIViewController!
    var lastError: Error!
    
    var match: GKMatch?
    weak var delegate: GameKitHelperDelegate?
    
    var enableGameCenter = false
    let presentAuthenticationViewController = "present_authentication_view_controller"
    
    let localPlayerIsAuthenticated = "local_player_authenticated"
    
    var matchStarted = false

    
    static let sharedGameKitHelper = GameKitHelper()
    
    override init() {
        super.init()
        enableGameCenter = true
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.isAuthenticated {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.localPlayerIsAuthenticated), object: nil)
            return
        }


        localPlayer.authenticateHandler = {(viewController: UIViewController!, error: Error!) -> Void in
            if error != nil {
                self.setLastError(error: error)
            }
            if viewController != nil {
                self.setAuthenticationViewController(viewController)
            }
            else if GKLocalPlayer.localPlayer().isAuthenticated {
                self.enableGameCenter = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.localPlayerIsAuthenticated), object: nil)
            }
            else {
                self.enableGameCenter = false
            }
            }
    }
    
    func setAuthenticationViewController(_ authenticationViewController: UIViewController?) {
        if authenticationViewController != nil {
            self.authenticationViewController = authenticationViewController
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.presentAuthenticationViewController), object: self)
        }

    }
    
    func setLastError(error: Error) {
        self.lastError = error
        if (lastError != nil) {
            print("GameKitHelper ERROR: " + lastError.localizedDescription)
        }

    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true) {
            //Dismiss
        }
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        self.match = match
        match.delegate = self
        if (!matchStarted && match.expectedPlayerCount == 0) {
            print("Ready to start")
        }
    }
    
    //GKMatchDelegate
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if (match != self.match) {
            return
        }
        delegate?.match(match: match, didReceive: data, fromPlayer: player.playerID!)
    }
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if (match != self.match){
            return
        }
        switch state {
        case .stateConnected:
            if (!matchStarted && match.expectedPlayerCount == 0) {
                print("Ready to start")
            }
        case .stateDisconnected:
            print("Player disconnected")
            matchStarted = false
            delegate?.matchEnded()
        case .stateUnknown:
            print("unknown")
        }
 
    }
    
    
    // The match was unable to be established with any players due to an error.
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        if (match != self.match) {
            return
        }
        matchStarted = false
        delegate?.matchEnded()
    }
    
    func findMatch(withMinPlayers minPlayers: Int, maxPlayers: Int, viewController: UIViewController?, delegate: GameKitHelperDelegate?) {
        print("hei")

        if !enableGameCenter {
            return
        }
        matchStarted = false
        match = nil
        self.delegate = delegate
        viewController?.dismiss(animated: false) {() -> Void in }
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self
        if let aMmvc = mmvc {
            viewController?.present(aMmvc, animated: true) {() -> Void in }
        }
    }


}
