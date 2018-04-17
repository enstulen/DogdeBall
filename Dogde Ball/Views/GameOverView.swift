//
//  GameOverView.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 17.04.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import Foundation

extension GameOverScene {
    func addGameOverElements(){
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
}
