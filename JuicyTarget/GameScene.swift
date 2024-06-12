//
//  GameScene.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 12/06/24.
//

import SpriteKit
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        for i in 0...3 {
            addBackgroundLayer(i)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func addBackgroundLayer(_ layerNumber: Int) {
        let background = SKSpriteNode(imageNamed: "layer\(layerNumber)")
        background.position = CGPoint(x: 590, y: 410)
        if layerNumber == 0 {
            background.blendMode = .replace
        }
        background.zPosition = CGFloat(layerNumber)
        addChild(background)
    }
}
