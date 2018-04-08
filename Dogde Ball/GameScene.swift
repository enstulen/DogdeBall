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
    

    var score: Int = 0
    var highScore: Int = 0
    
    var players = [SKSpriteNode]()
    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var networkingEngine: MultiPlayerNetworking!
    var currentIndex: Int!
    
    var initialPlayerPosition: CGPoint!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let movePercent = touch.location(in: self.view).x
            print(movePercent)
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            
            //let movePercent = normalizedForce * self.size.width - 25
            
            if currentIndex == -1 {
                print("currentindex = -1")
                return
            }
            players[currentIndex].position.x = movePercent
            networkingEngine.sendMove(movePercent: Float(movePercent))
            
        }
    }
    
    func movePlayerAtIndex(index: Int, movePercent: Float) {
        players[currentIndex].position.x = CGFloat(movePercent)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    func resetPlayerPosition() {
        players[currentIndex].position = initialPlayerPosition
        networkingEngine.sendMove(movePercent: Float(initialPlayerPosition.x))
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        addScoreLabel()
        addPlayer()
        addPlayer2()
        
        currentIndex = -1
        
        scheduledTimerWithTimeInterval()
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
            //showGameOver()
        }
    }
    
    func showGameOver() {
        if(score>=highScore){
            highScore = score
        }
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: score)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func scheduledTimerWithTimeInterval(){
        var timer = Timer()
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        score = score + 1
        scoreLabel.text = String(score)
    }
    
    func setCurrentPlayerIndex(index :Int) {
        currentIndex = index
    }
}
