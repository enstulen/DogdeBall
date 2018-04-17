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
    var isMultiPlayer = false
    
    var players = [SKShapeNode]()
    var player: SKShapeNode!
    var player2: SKShapeNode!
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
                movePercent = touch.location(in: self).x
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
        let playingTime = calculatePlayingTime()
        var randomNumber = 0
        print(playingTime)
        if (playingTime < 100) {
            randomNumber = Int(arc4random_uniform(4)) //only easy
        } else if (playingTime < 300) {
            randomNumber = Int(arc4random_uniform(7)) //harder obstacles
        } else if (playingTime < 500) {
            randomNumber = Int(arc4random_uniform(10)) //even harder obstacles
        } else if (playingTime < 800) {
            randomNumber = randomRange(4..<10) //no very esay ones
        } else {
            randomNumber = randomRange(7..<14) //only medium and hard obstacles
        }
        
        if networkingEngine != nil {
            if networkingEngine.isPlayer1 {
                addRowFromRandomNumber(randomNumber: randomNumber)
                sendRow(randomNumber: randomNumber)
            } else {
                return
            }
        } else {
            addRowFromRandomNumber(randomNumber: randomNumber)
        }
        
    }
    
    func sendRow(randomNumber: Int) {
        if networkingEngine != nil {
            networkingEngine.sendRow(randomNumber: randomNumber)
        }
    }
    
    func addRowFromRandomNumber(randomNumber: Int){
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
    
    func calculatePlayingTime() -> UInt64 {
        return (DispatchTime.now().rawValue - startTime.rawValue) / 1_000_000
    }
    
    var gap = 0
    override func update(_ currentTime: TimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
        if gap >= 10 {
            updateCounting()
            gap = 0
        }
        gap+=1
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
        GameKitHelper.sharedGameKitHelper.reportScore(score: Int64(score), forLeaderBoardId: "DogdeballLeaderBoard")
        //GameKitHelper.sharedGameKitHelper.reportScore(score: Int64(score), forLeaderBoardId: "DogdeballLeaderBoardRecent")
        let gameOverScene = GameOverScene(size: self.size, score: score, localPlayerWin: localPlayerWin)
        self.view?.presentScene(gameOverScene)
        
    }
    
    
    @objc func updateCounting(){
        score = score + 1
        if scoreLabel != nil {
            scoreLabel.text = String(score)
        }
    }
    
    func setCurrentPlayerIndex(index :Int) {
        currentIndex = index
    }
}
