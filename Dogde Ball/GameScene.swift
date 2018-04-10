//
//  GameScene.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 05.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RowType: Int {
    //very easy:
    case oneM = 0
    case oneL = 1
    case oneMRight = 2
    case oneLRight = 3
    
    //easy:
    case oneMLeft = 4
    case oneLLeft = 5
    case twoS = 6
    
    //medium:
    case twoM = 7
    case sAndM = 8
    case mAndS = 9
    
    //hard:
    case threeS = 10
    case xSAndL = 11
    case lAndXs = 12
    case twoXsAndM = 13
}

class GameScene: SKScene, SKPhysicsContactDelegate, MultiplayerNetworkingProtocol{    
    
    func matchEnded() {
        print("ended")
    }
    
    
    var score: Int = 0
    var highScore: Int = 0
    var isMultiPlayer = false
    
    var players = [SKSpriteNode]()
    var player: SKSpriteNode!
    var player2: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var networkingEngine: MultiPlayerNetworking!
    var currentIndex: Int!
    
    var initialPlayerPosition: CGPoint!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let maximumPossibleForce = touch.maximumPossibleForce
            var movePercent: CGFloat = 0
            
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            if (maximumPossibleForce == 0) {
                movePercent = touch.location(in: self.view).x
            } else {
                movePercent = normalizedForce * self.size.width - 25
            }
            
            players[currentIndex].position.x = CGFloat(movePercent)
            sendMove(movePercent: Float(movePercent))
            
        }
    }
    
    func addElements(){
        addPlayer()
        if (isMultiPlayer) {
            addPlayer2()
        }else {
            addScoreLabel()
            scheduledTimerWithTimeInterval()
        }
    }
    
    func pause(){
        if self.scene?.view?.isPaused == true {
            self.scene?.view?.isPaused = false
        } else {
            self.scene?.view?.isPaused = true
        }
    }
    
    func movePlayerAtIndex(index: Int, movePercent: Float) {
        players[index].position.x = CGFloat(movePercent)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    func sendMove(movePercent: Float){
        if networkingEngine != nil {
            networkingEngine.sendMove(movePercent: movePercent)
        }
    }
    
    func resetPlayerPosition() {
        players[currentIndex].position = initialPlayerPosition
        sendMove(movePercent: Float(initialPlayerPosition.x))
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        currentIndex = 0
        
    }
    
    func randomRange(_ range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    func addRandomRow() {
        let playingTime = calculatePlayingTimeInMilliseconds()
        var randomNumber = 0
        
        if (playingTime < 5000) {
            randomNumber = Int(arc4random_uniform(4)) //only easy first 5 sec
        } else if (playingTime < 10000) {
            randomNumber = Int(arc4random_uniform(7)) //harder obstacles after 5 seconds
        } else if (playingTime < 15000) {
            randomNumber = Int(arc4random_uniform(10)) //even harder obstacles after 10 seconds
        } else if (playingTime < 20000) {
            randomNumber = randomRange(4..<10) //no very esay ones after 15 seconds
        } else {
            randomNumber = randomRange(7..<14) //only medium and hard obstacles after 20 seconds
        }
        
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
        case 6:
            addRow(type: RowType(rawValue: 6)!)
            break
        case 7:
            addRow(type: RowType(rawValue: 7)!)
            break
        case 8:
            addRow(type: RowType(rawValue: 8)!)
            break
        case 9:
            addRow(type: RowType(rawValue: 9)!)
            break
        case 10:
            addRow(type: RowType(rawValue: 10)!)
            break
        case 11:
            addRow(type: RowType(rawValue: 11)!)
            break
        case 12:
            addRow(type: RowType(rawValue: 12)!)
            break
        case 13:
            addRow(type: RowType(rawValue: 13)!)
            break
        default:
            break
        }
    }
    
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    var startTime = DispatchTime.now()
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 1.5 {
            lastYieldTimeInterval = 0
            addRandomRow()
        }
    }
    
    func calculatePlayingTimeInMilliseconds() -> UInt64 {
        return (DispatchTime.now().rawValue - startTime.rawValue) / 1_000_000
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
        
        if (isMultiPlayer && networkingEngine != nil) {
            if networkingEngine.isLocalPlayerPlayer1() && contact.bodyA.node?.name == "PLAYER" {
                print("SENDING PLAYER1 LOST")

                networkingEngine.sendGameOver(player1won: false)
                showGameOver(localPlayerWin: false)
            }
            if networkingEngine.isLocalPlayerPlayer1() && contact.bodyA.node?.name == "PLAYER2" {
                print("SENDING PLAYER1 WON")

                networkingEngine.sendGameOver(player1won: true)
                showGameOver(localPlayerWin: true)
            }
        } else {
            if contact.bodyA.node?.name == "PLAYER" {
                showGameOver(localPlayerWin: nil)
            }
        }
        
        
    }
    
    func showGameOver(localPlayerWin: Bool?) {
        if(score>=highScore){
            highScore = score
        }
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: score, localPlayerWin: localPlayerWin)
        self.view?.presentScene(gameOverScene)
        
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
