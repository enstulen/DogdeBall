//
//  PauseModalViewController.swift
//  Dogde Ball
//
//  Created by August Lund Eilertsen on 10.04.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import SpriteKit

class PauseModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.scene?.view?.isPaused = false
        // Do any additional setup after loading the view.
    }

  
    @IBAction func continueGame(_ sender: Any) {
        
        //dismiss(animated: true)
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene()
        //self.view?.presentScene(gameScene, transition: transition)
    }
    
    @IBAction func exit(_ sender: Any) {
    }
    
}
