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
        
        self.backgroundColor = SKColor.black
        var message = ""

        if localPlayerWin == true {
            message = "YOU WIN"
        } else {
            message = "YOU LOSE"
        }
        if localPlayerWin != nil {
            isMultiPlayer = true
        } else {
            message = "GAME OVER"
        }
        let defaults = UserDefaults.standard
        
        if(score >= defaults.integer(forKey: "HighScore")){
            defaults.set(score, forKey: "HighScore")
        }
        
        let label = SKLabelNode(fontNamed: "DINCondensed-Bold")
        label.fontSize = 100
        label.text = message
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0.5*self.size.width, y: 0.75*self.size.height)
        addChild(label)
        
        //If its singleplayer, show the score
        if localPlayerWin == nil {
            let scoreLabel = SKLabelNode(fontNamed: "DINCondensed-Bold")
            scoreLabel.fontSize = 70
            scoreLabel.text = "Score: " + String(score)
            scoreLabel.fontColor = SKColor.white
            scoreLabel.position = CGPoint(x: 0.5*self.size.width, y: 0.5*self.size.height)
            addChild(scoreLabel)
            
            let highScoreLabel = SKLabelNode(fontNamed: "DINCondensed-Bold")
            highScoreLabel.fontSize = 70
            highScoreLabel.text = "High Score: " + String(defaults.integer(forKey: "HighScore"))
            highScoreLabel.fontColor = SKColor.white
            highScoreLabel.position = CGPoint(x: 0.5*self.size.width, y: 0.4*self.size.height)
            addChild(highScoreLabel)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.addElements()
        
        if isMultiPlayer == true {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "go_to_main_menu"), object: self)
        } else {
            self.view?.presentScene(gameScene)
        }
    }
    
}
