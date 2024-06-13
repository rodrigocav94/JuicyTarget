//
//  Heart.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 13/06/24.
//

import SpriteKit

class Heart: SKNode {
    var node: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        let board = SKSpriteNode(imageNamed: "heart")
        addChild(board)
        node = board
    }
    
    func lose() {
        let scaleDown = SKAction.scale(to: 0, duration: 0.5)
        let removeItself = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        node.run(SKAction.sequence([scaleDown, removeItself]))
    }
}
