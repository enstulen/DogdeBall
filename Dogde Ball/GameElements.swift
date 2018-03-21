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
        
        initialPlayerPosition = player.position
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
    
    
    
}


