//
//  Obstacle.swift
//  Dogde Ball
//
//  Created by Anniken Holst on 12.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit

enum ObstacleType: Int {
    case Small = 0
    case Medium = 1
    case Large = 2
    case xSmall = 3
}

class Obstacle: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type: ObstacleType, frameSize: CGSize) {
        super.init(texture: nil, color: UIColor.white, size: CGSize(width: 0, height: 30))

        self.name = "OBSTACLE"
        self.physicsBody?.isDynamic = true
        
        self.setObstacleSize(type: type, frameSize: frameSize)
        
        self.position = CGPoint(x: 0, y: frameSize.height + frameSize.height)
        self.setPhysicsProperties()
    }
    
    private func setPhysicsProperties() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        self.physicsBody?.collisionBitMask = 0
    }
    
    private func setObstacleSize(type: ObstacleType, frameSize: CGSize) {
        switch type {
        case .Small:
            self.size.width = frameSize.width * 0.2
            break
        case .Medium:
            self.size.width = frameSize.width * 0.35
            break
        case .Large:
            self.size.width = frameSize.width * 0.75
            break
        case .xSmall:
            self.size.width = frameSize.width * 0.1
            break
        }
    }
    
    func setXPosition(xPos: CGFloat) {
        self.position = CGPoint(x: xPos, y: self.position.y)
    }
    
    

}
