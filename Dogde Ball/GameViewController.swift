//
//  GameViewController.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 05.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    var networkingEngine: MultiPlayerNetworking!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAuthenticationViewController), name: Notification.Name(rawValue: GameKitHelper.sharedGameKitHelper.presentAuthenticationViewController) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerAuthenticated), name: NSNotification.Name(rawValue: GameKitHelper.sharedGameKitHelper.localPlayerIsAuthenticated), object: nil)

        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @objc func showAuthenticationViewController() {
        let gamekitHelper = GameKitHelper.sharedGameKitHelper
        self.present(gamekitHelper.authenticationViewController, animated: true) {
            print("halla")
        }
    }
    
    @objc func playerAuthenticated() {
        let skView = view as! SKView
        if let scene = skView.scene as? GameScene {
            print("playerauth!!!!")
            networkingEngine = MultiPlayerNetworking()
            networkingEngine.delegate = scene as MultiplayerNetworkingProtocol
            scene.networkingEngine = networkingEngine
            GameKitHelper.sharedGameKitHelper.findMatch(withMinPlayers: 2, maxPlayers: 2, viewController: self, delegate: networkingEngine)
        }

    }


    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

