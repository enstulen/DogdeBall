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
        switch type {
        case .oneS:
            let obst = Obstacle(type: .Small, frameSize: self.size)
            obst.setXPosition(xPos: self.size.width/2)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneM:
            let obst = Obstacle(type: .Medium, frameSize: self.size)
            obst.setXPosition(xPos: self.size.width/2)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneL:
            let obst = Obstacle(type: .Large, frameSize: self.size)
            obst.setXPosition(xPos: self.size.width/2)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .twoS:
            let obst1 = Obstacle(type: .Small, frameSize: self.size)
            let obst2 = Obstacle(type: .Small, frameSize: self.size)
            
            obst1.setXPosition(xPos: obst1.size.width + 50)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width - 50)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            break
        case .twoM:
            let obst1 = Obstacle(type: .Medium, frameSize: self.size)
            let obst2 = Obstacle(type: .Medium, frameSize: self.size)
            
            obst1.setXPosition(xPos: obst1.size.width / 2 + 50)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width/2 - 50)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            break
        case .threeS:
            let obst1 = Obstacle(type: .Small, frameSize: self.size)
            let obst2 = Obstacle(type: .Small, frameSize: self.size)
            let obst3 = Obstacle(type: .Small, frameSize: self.size)

            obst1.setXPosition(xPos: obst1.size.width / 2 + 50) // left
            obst2.setXPosition(xPos: self.size.width - obst2.size.width / 2 - 50) // right
            obst3.setXPosition(xPos: self.size.width / 2) // center

            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addMovement(obstacle: obst3)
            
            addChild(obst1)
            addChild(obst2)
            addChild(obst3)

            break
        case .sAndM:
            let obst1 = Obstacle(type: .Small, frameSize: self.size)
            let obst2 = Obstacle(type: .Medium, frameSize: self.size)
            
            obst1.setXPosition(xPos: obst1.size.width + 50)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width/2 - 50)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            
            break
        case .mAndS:
            let obst1 = Obstacle(type: .Small, frameSize: self.size)
            let obst2 = Obstacle(type: .Medium, frameSize: self.size)
            
            obst1.setXPosition(xPos: obst1.size.width / 2 + 50)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width - 50)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            
            addChild(obst1)
            addChild(obst2)
            
            break
        case .oneMLeft:
            let obst = Obstacle(type: .Medium, frameSize: self.size)
            obst.setXPosition(xPos: obst.size.width / 2 + 50)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneLLeft:
            let obst = Obstacle(type: .Large, frameSize: self.size)
            obst.setXPosition(xPos: obst.size.width/2)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneMRight:
            let obst = Obstacle(type: .Medium, frameSize: self.size)
            obst.setXPosition(xPos: self.size.width - obst.size.width/2 - 50)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .oneLRight:
            let obst = Obstacle(type: .Large, frameSize: self.size)
            obst.setXPosition(xPos: self.size.width - obst.size.width/2)
            addMovement(obstacle: obst)
            addChild(obst)
            break
        case .xSAndL:
            let obst1 = Obstacle(type: .xSmall, frameSize: self.size)
            let obst2 = Obstacle(type: .Large, frameSize: self.size)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width/2)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addChild(obst1)
            addChild(obst2)
            break
        case .lAndXs:
            let obst1 = Obstacle(type: .Large, frameSize: self.size)
            let obst2 = Obstacle(type: .xSmall, frameSize: self.size)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: self.size.width - obst2.size.width/2)
            
            addMovement(obstacle: obst1)
            addMovement(obstacle: obst2)
            addChild(obst1)
            addChild(obst2)
            break
        case .twoXsAndM:
            let obst1 = Obstacle(type: .xSmall, frameSize: self.size)
            let obst2 = Obstacle(type: .xSmall, frameSize: self.size)
            let obst3 = Obstacle(type: .Medium, frameSize: self.size)
            
            obst1.setXPosition(xPos: obst1.size.width / 2) // left
            obst2.setXPosition(xPos: self.size.width - obst2.size.width / 2) // right
            obst3.setXPosition(xPos: self.size.width / 2) // center
            
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


