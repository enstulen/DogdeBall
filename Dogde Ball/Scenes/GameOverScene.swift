//
//  GameOverScene.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 05.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var isMultiPlayer = false
    
    init(size: CGSize, score: Int, localPlayerWin: Bool?) {
        super.init(size: size)
        addGameOverElements()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        gameScene.addElements()
        
        if isMultiPlayer == true {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "go_to_main_menu"), object: self)
        } else {
            self.view?.presentScene(gameScene)
        }
    }
    
}
