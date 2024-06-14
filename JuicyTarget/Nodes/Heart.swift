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
    
    func shrink(reverse: Bool = false) {
        node.run(SKAction.scale(to: reverse ? 1 : 0, duration: 0.5))
    }
}
