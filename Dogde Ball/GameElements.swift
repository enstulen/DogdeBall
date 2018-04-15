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
        player = SKShapeNode(circleOfRadius: 25)
        player.fillColor = UIColor(red:0.25, green:0.99, blue:0.99, alpha:1.00)
        player.strokeColor = UIColor.white
        player.lineWidth = 5
        player.position = CGPoint(x: 25, y: 400)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        if let thrusterPath = Bundle.main.path(forResource: "ParticleEmitter", ofType: "sks") {
            if let thruster = NSKeyedUnarchiver.unarchiveObject(withFile: thrusterPath) as? SKEmitterNode {
                thruster.xScale = 2
                thruster.yScale = 2
                player.addChild(thruster)
            }
        }
        
        addChild(player)
        players.append(player)
        
        initialPlayerPosition = player.position
    }
    
    func addPlayer2(){
        player2 = SKShapeNode(circleOfRadius: 25)
        player2.fillColor = UIColor(red:0.95, green:0.13, blue:0.39, alpha:1.00)
        player2.position = CGPoint(x: 25, y: 400)
        player.strokeColor = UIColor.white
        player.lineWidth = 5
        player2.name = "PLAYER2"
        player2.physicsBody?.isDynamic = false
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.frame.size)
        player2.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player2.physicsBody?.collisionBitMask = 0
        player2.physicsBody?.contactTestBitMask = CollisionBitMask.Obstacle
        
        if let thrusterPath = Bundle.main.path(forResource: "ParticleEmitter2", ofType: "sks") {
            if let thruster = NSKeyedUnarchiver.unarchiveObject(withFile: thrusterPath) as? SKEmitterNode {
                thruster.xScale = 2
                thruster.yScale = 2
                player2.addChild(thruster)
            }
        }
        
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
        scoreLabel.fontName = "DINCondensed-Bold"
        scoreLabel.fontSize = 90

        addChild(scoreLabel)
    }
}

