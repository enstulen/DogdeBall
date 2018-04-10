//
//  ObstacleRow.swift
//  Dogde Ball
//
//  Created by Anniken Holst on 21.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import SpriteKit

class ObstacleRow {
    
    var obstacles: [Obstacle]
    
    init(type: RowType, frameSize: CGSize) {
        obstacles = []
        setObstacles(type: type, frameSize: frameSize)
    }
    
    public func getObstacles() -> [Obstacle] {
        return obstacles
    }
    
    private func setObstacles(type: RowType, frameSize: CGSize) {
        switch type {
            
        case .oneM:
            obstacles = [Obstacle(type: .Medium, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: frameSize.width / 2)
            break
            
        case .oneL:
            obstacles = [Obstacle(type: .Large, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: frameSize.width / 2)
            break
            
        case .twoS:
            let obst1 = Obstacle(type: .Small, frameSize: frameSize)
            let obst2 = Obstacle(type: .Small, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width/2)
            obstacles = [obst1, obst2]
            break
            
        case .twoM:
            let obst1 = Obstacle(type: .Medium, frameSize: frameSize)
            let obst2 = Obstacle(type: .Medium, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2)
            obstacles = [obst1, obst2]
            break
            
        case .threeS:
            let obst1 = Obstacle(type: .Small, frameSize: frameSize)
            let obst2 = Obstacle(type: .Small, frameSize: frameSize)
            let obst3 = Obstacle(type: .Small, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2) // left
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2) // right
            obst3.setXPosition(xPos: frameSize.width / 2) // center
            obstacles = [obst1, obst2, obst3]
            break
            
        case .sAndM:
            let obst1 = Obstacle(type: .Small, frameSize: frameSize)
            let obst2 = Obstacle(type: .Medium, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2)
            obstacles = [obst1, obst2]
            break
            
        case .mAndS:
            let obst1 = Obstacle(type: .Medium, frameSize: frameSize)
            let obst2 = Obstacle(type: .Small, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2)
            obstacles = [obst1, obst2]
            break
            
        case .oneMLeft:
            obstacles = [Obstacle(type: .Medium, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: obstacles[0].size.width / 2)
            break
            
        case .oneLLeft:
            obstacles = [Obstacle(type: .Large, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: obstacles[0].size.width / 2)
            break
            
        case .oneMRight:
            obstacles = [Obstacle(type: .Medium, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: frameSize.width - obstacles[0].size.width / 2)
            break
            
        case .oneLRight:
            obstacles = [Obstacle(type: .Large, frameSize: frameSize)]
            obstacles[0].setXPosition(xPos: frameSize.width - obstacles[0].size.width / 2)
            break
            
        case .xSAndL:
            let obst1 = Obstacle(type: .xSmall, frameSize: frameSize)
            let obst2 = Obstacle(type: .Large, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2)
            obstacles = [obst1, obst2]
            break
           
        case .lAndXs:
            let obst1 = Obstacle(type: .Large, frameSize: frameSize)
            let obst2 = Obstacle(type: .xSmall, frameSize: frameSize)
            obst1.setXPosition(xPos: obst1.size.width / 2)
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2)
            obstacles = [obst1, obst2]
            break
        
        case .twoXsAndM:
            let obst1 = Obstacle(type: .xSmall, frameSize: frameSize)
            let obst2 = Obstacle(type: .xSmall, frameSize: frameSize)
            let obst3 = Obstacle(type: .Medium, frameSize: frameSize)
            
            obst1.setXPosition(xPos: obst1.size.width / 2) // left
            obst2.setXPosition(xPos: frameSize.width - obst2.size.width / 2) // right
            obst3.setXPosition(xPos: frameSize.width / 2) // center
            obstacles = [obst1, obst2, obst3]
            break
        }
    }
    
}
