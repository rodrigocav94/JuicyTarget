//
//  Board.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 12/06/24.
//

import SpriteKit

class Board: SKNode {
    var node: SKSpriteNode!
    var isVisible: Bool = true
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let board = SKSpriteNode(imageNamed: "board")
        addChild(board)
        
        let enemyName = "enemy\(Int.random(in: 1...6))"
        let fruitName = "fruit\(Int.random(in: 1...10))"
        
        let isEnemy = Bool.random()
        let target = SKSpriteNode(imageNamed: isEnemy ? enemyName : fruitName)
        self.name = isEnemy ? "bad" : "good"
        board.addChild(target)
        target.position = CGPoint(x: -10, y: 25)
        let goesToTheRight = position.x <= 0
        if goesToTheRight {
            target.xScale = -1.0
        }
        
        node = board
        
        board.jiggle(duration: 0.4)
    }
    
    func hit() {
        if !isVisible { return }
        self.isVisible = false
        node.physicsBody?.velocity = CGVector(dx: 0, dy: -600) // Velocity going downwards.
        node.physicsBody?.linearDamping = -10 // Movement speed will increase slow over time.
        let delay = SKAction.wait(forDuration: 0.5)
        let removeItself = SKAction.run { [weak self] in
            self?.removeFromParent()
        }
        node.run(SKAction.sequence([delay, removeItself]))
    }
}
