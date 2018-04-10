//
//  PauseModalViewController.swift
//  Dogde Ball
//
//  Created by August Lund Eilertsen on 10.04.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class PauseModalViewController: UIViewController {

    @IBOutlet weak var modalView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.layer.cornerRadius = 10
        
    }


    @IBAction func continueGame(_ sender: Any) {
       
        dismiss(animated: true)
    }
    
    @IBAction func exit(_ sender: Any) {
        self.performSegue(withIdentifier: "exitSegue", sender: self)
    }
    
}
