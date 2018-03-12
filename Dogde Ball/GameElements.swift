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
enum ObstacleTye: Int {
    case Small = 0
    case Medium = 1
    case Large = 2
    case xSmall = 3
}

enum RowType: Int {
    case oneS = 0
    case oneM = 1
    case oneL = 2
    case twoS = 3
    case twoM = 4
    case threeS = 5
    case sAndM = 6
    case mAndS = 7
    case oneMLeft = 8
    case oneLLeft = 9
    case oneMRight = 10
    case oneLRight = 11
    case xSAndL = 12
    case lAndXs = 13
    case twoXsAndM = 14
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
    
    func addObstacle(type: ObstacleTye) -> SKSpriteNode {
        let obstacle = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 30))
        obstacle.name = "OBSTACLE"
        obstacle.physicsBody?.isDynamic = true
        
        switch type {
        case .Small:
            obstacle.size.width = self.size.width * 0.2
            break
        case .Medium:
            obstacle.size.width = self.size.width * 0.35
            break
        case .Large:
            obstacle.size.width = self.size.width * 0.75
            break
        case .xSmall:
            obstacle.size.width = self.size.width * 0.1
            break
        }
        
        obstacle.position = CGPoint(x: 0, y: self.size.height + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        
        return obstacle
        
    }
    
    func addMovement(obstacle: SKSpriteNode){
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.size.height), duration: TimeInterval(3)))
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    
    
    func addRow(type: RowType) {
        switch type {
        case .oneS:
            let obst = addObstacle(type: .Small)
            obst.position = CGPoint(x: self.size.width/2, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneM:
            let obst = addObstacle(type: .Medium)
            obst.position = CGPoint(x: self.size.width/2, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneL:
            let obst = addObstacle(type: .Large)
            obst.position = CGPoint(x: self.size.width/2, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .twoS:
            let obst1 = addObstacle(type: .Small)
            let obst2 = addObstacle(type: .Small)
            
            obst1.position = CGPoint(x: obst1.size.width + 50, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width - 50, y: obst1.position.y)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            break
        case .twoM:
            let obst1 = addObstacle(type: .Medium)
            let obst2 = addObstacle(type: .Medium)
            
            obst1.position = CGPoint(x: obst1.size.width / 2 + 50, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width/2 - 50, y: obst1.position.y)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            break
        case .threeS:
            let obst1 = addObstacle(type: .Small)
            let obst2 = addObstacle(type: .Small)
            let obst3 = addObstacle(type: .Small)

            obst1.position = CGPoint(x: obst1.size.width / 2 + 50, y: obst1.position.y) // left
            obst2.position = CGPoint(x: self.size.width - obst2.size.width / 2 - 50, y: obst1.position.y) // right
            obst3.position = CGPoint(x: self.size.width / 2, y: obst1.position.y) // center

            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addMovement(obstacle: obst3)
            
            addChild(obst1)
            addChild(obst2)
            addChild(obst3)

            break
        case .sAndM:
            let obst1 = addObstacle(type: .Small)
            let obst2 = addObstacle(type: .Medium)
            
            obst1.position = CGPoint(x: obst1.size.width + 50, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width/2 - 50, y: obst1.position.y)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            
            break
        case .mAndS:
            let obst1 = addObstacle(type: .Small)
            let obst2 = addObstacle(type: .Medium)
            
            obst1.position = CGPoint(x: obst1.size.width / 2 + 50, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width - 50, y: obst1.position.y)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            
            break
        case .oneMLeft:
            let obst = addObstacle(type: .Medium)
            obst.position = CGPoint(x: obst.size.width / 2 + 50, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneLLeft:
            let obst = addObstacle(type: .Large)
            obst.position = CGPoint(x: obst.size.width/2, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneMRight:
            let obst = addObstacle(type: .Medium)
            obst.position = CGPoint(x: self.size.width - obst.size.width/2 - 50, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneLRight:
            let obst = addObstacle(type: .Large)
            obst.position = CGPoint(x: self.size.width - obst.size.width/2, y: obst.position.y)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .xSAndL:
            let obst1 = addObstacle(type: .xSmall)
            let obst2 = addObstacle(type: .Large)
            obst1.position = CGPoint(x: obst1.size.width / 2, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width/2, y: obst2.position.y)
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addChild(obst1)
            addChild(obst2)
            break
        case .lAndXs:
            let obst1 = addObstacle(type: .Large)
            let obst2 = addObstacle(type: .xSmall)
            obst1.position = CGPoint(x: obst1.size.width / 2, y: obst1.position.y)
            obst2.position = CGPoint(x: self.size.width - obst2.size.width/2, y: obst2.position.y)
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addChild(obst1)
            addChild(obst2)
            break
        case .twoXsAndM:
            let obst1 = addObstacle(type: .xSmall)
            let obst2 = addObstacle(type: .xSmall)
            let obst3 = addObstacle(type: .Medium)
            
            obst1.position = CGPoint(x: obst1.size.width / 2, y: obst1.position.y) // left
            obst2.position = CGPoint(x: self.size.width - obst2.size.width / 2, y: obst2.position.y) // right
            obst3.position = CGPoint(x: self.size.width / 2, y: obst3.position.y) // center
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addMovement(obstacle: obst3)
            
            addChild(obst1)
            addChild(obst2)
            addChild(obst3)
            break
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


