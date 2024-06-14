//
//  SKNode+Extensions.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 13/06/24.
//

import SpriteKit

extension SKNode {
    func jiggle(duration: Double) {
        let jiggleDown = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: duration / 2)
        let jiggleUp = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: duration / 2)
        let jiggleSequence = SKAction.sequence([jiggleDown, jiggleUp])
        let jiggleForever = SKAction.repeatForever(jiggleSequence)
        self.run(jiggleForever)
    }
}
