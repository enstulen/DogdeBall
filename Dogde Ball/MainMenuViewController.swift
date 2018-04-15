//
//  MainMenuViewController.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 09.04.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class MainMenuViewController: UIViewController {
    
    @IBAction func highscoreButtonPressed(_ sender: Any) {
        GameKitHelper.sharedGameKitHelper.presentHighscore(viewController: self)
 
    }
    @IBOutlet weak var highscoreButton: UIButton!
    @IBAction func singlePlayerButtonPressed(_ sender: Any) {
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as? GameViewController {
            navigationController?.pushViewController(gameViewController, animated: false)
        }
    }
    @IBAction func multiPlayerButtonPressed(_ sender: Any) {
        if let gameViewController = storyboard?.instantiateViewController(withIdentifier: "gameViewController") as? GameViewController {
            gameViewController.isMultiPlayer = true
            navigationController?.pushViewController(gameViewController, animated: false)
        }
        
    }
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiPlayerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        //self.view.scene.backgroundColor = SKColor.black
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAuthenticationViewController), name: Notification.Name(rawValue: GameKitHelper.sharedGameKitHelper.presentAuthenticationViewController) , object: nil)
        
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func showAuthenticationViewController() {
        let gamekitHelper = GameKitHelper.sharedGameKitHelper
        self.present(gamekitHelper.authenticationViewController, animated: true) {
            print("halla")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
