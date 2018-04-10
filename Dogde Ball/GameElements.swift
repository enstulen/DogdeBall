//
//  GameElements.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 05.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let Player: UInt32 = 0x00
    static let Obstacle: UInt32 = 0x01

}


extension GameScene {
    
    func addPlayer(){
        player = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: 25, y: 350)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        addChild(player)
        players.append(player)
        
        initialPlayerPosition = player.position
    }
    
    func addPlayer2(){
        player2 = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 50, height: 50))
        player2.position = CGPoint(x: 25, y: 350)
        player2.name = "PLAYER2"
        player2.physicsBody?.isDynamic = false
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size)
        player2.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player2.physicsBody?.collisionBitMask = 0
        player2.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        addChild(player2)
        players.append(player2)

        initialPlayerPosition = player2.position
    }
    
    
    func addMovement(obstacle: SKSpriteNode){
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.size.height), duration: TimeInterval(3)))
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    func addRow(type: RowType) {
        let row = ObstacleRow(type: type, frameSize: self.size)
        for obst in row.getObstacles() {
            addMovement(obstacle: obst)
            addChild(obst)
        }
    }
        
    func addScoreLabel(){
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: 0.9*self.size.width, y: 0.9*self.size.height)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreLabel.fontName = "Optima-ExtraBlack"
        scoreLabel.fontSize = 70

        addChild(scoreLabel)
    }
}

