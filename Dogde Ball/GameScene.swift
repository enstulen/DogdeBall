//
//  GameScene.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 05.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate, MultiplayerNetworkingProtocol{
    func matchEnded() {
        print("ended")
    }
    

    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    var networkingEngine: MultiPlayerNetworking!
    
    var initialPlayerPosition: CGPoint!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            
            player.position.x = normalizedForce * self.size.width - 25

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    func resetPlayerPosition() {
        player.position = initialPlayerPosition
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        addPlayer()
        
    }
    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(6))
            
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        default:
            break
        }
    }
    
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 1.5 {
            lastYieldTimeInterval = 0
            addRandomRow()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "PLAYER" {
            showGameOver()
        }
    }
    
    func showGameOver() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
}
