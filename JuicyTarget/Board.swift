//
//  Board.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 12/06/24.
//

import SpriteKit

class Board: SKNode {
    var node: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let board = SKSpriteNode(imageNamed: "board")
        addChild(board)
        
        let enemyName = "enemy\(Int.random(in: 1...6))"
        let fruitName = "fruit\(Int.random(in: 1...10))"
        
        let isEnemy = Bool.random()
        let target = SKSpriteNode(imageNamed: isEnemy ? enemyName : fruitName)
        board.addChild(target)
        target.position = CGPoint(x: -10, y: 25)
        node = board
    }
}
