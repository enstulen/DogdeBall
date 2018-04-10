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
    var isMultiPlayer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerAuthenticated), name: NSNotification.Name(rawValue: GameKitHelper.sharedGameKitHelper.localPlayerIsAuthenticated), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startMultiplayerGame), name: NSNotification.Name(rawValue: "start_multiplayer_game"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToMainMenu), name: NSNotification.Name(rawValue: "go_to_main_menu"), object: nil)

        
        startGame()
        
        if isMultiPlayer == true {
            let skView = view as! SKView
            if let scene = skView.scene as? GameScene {
                scene.isMultiPlayer = true
                networkingEngine = MultiPlayerNetworking()
                networkingEngine.delegate = scene as MultiplayerNetworkingProtocol
                scene.networkingEngine = networkingEngine
                GameKitHelper.sharedGameKitHelper.findMatch(withMinPlayers: 2, maxPlayers: 2, viewController: self, delegate: networkingEngine)
            }
        }
        
    }
    
    @objc func goToMainMenu() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func startMultiplayerGame() {
        let skView = view as! SKView
        if let scene = skView.scene as? GameScene {
            if isMultiPlayer {
                scene.view?.isPaused = false
            }
        }
    }
    
    
    func startGame(){
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
                if isMultiPlayer {
                    scene.isMultiPlayer = true
                    scene.view?.isPaused = true
                }
                scene.addElements()

            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    
    @objc func playerAuthenticated() {
        print("here1")


    }
    
    
    @IBAction func pauseSingleplayer(_ sender: Any) {
        
        //gameScene.view?.isPaused = true
        gameScene.scene?.view?.isPaused = true
        gameView.scene?.view?.isPaused = true
        self.performSegue(withIdentifier: "pauseSegue", sender: self)
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

