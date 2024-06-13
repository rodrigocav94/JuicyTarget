//
//  GameScene.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 12/06/24.
//

import SpriteKit

class GameScene: SKScene {
    var backgrounds: [SKSpriteNode] = []
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        addBackgroundLayer()
        
        buildScore()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let unreachableNodes = children.filter {
            $0.position.x < -300 || $0.position.x > 1400
        }
        for node in unreachableNodes {
            node.removeFromParent()
        }
    }
    
    func addBackgroundLayer() {
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "layer\(i)")
            background.position = CGPoint(x: 590, y: 410)
            if i == 0 {
                background.blendMode = .replace
                background.zPosition = -1
            } else {
                background.zPosition = CGFloat(i)
            }
            addChild(background)
            backgrounds.append(background)
        }
    }
    
    func buildScore() {
//        let scoreIcon = SKSpriteNode(imageNamed: "basket")
//        scoreIcon.position = CGPoint(x: 1020, y: 90)
//        scoreIcon.zPosition = 4
//
//        addChild(scoreIcon)

    }
    
    @objc func createBoard() {
        let rows = [460, 330, 200]
        let rowIndex = Int.random(in: 0...2)
        let goesToTheLeft = rowIndex == 1
        let startingPoint = goesToTheLeft ? 1300 : 0
        let direction = goesToTheLeft ? -500 : 500
        
        let position = CGPoint(x: startingPoint, y: rows[rowIndex])
        let sprite = Board()
        sprite.configure(at: position)
        addChild(sprite)
        
        sprite.node.zPosition = backgrounds[rowIndex].zPosition
        
        sprite.node.physicsBody = SKPhysicsBody(rectangleOf: sprite.node.size)
        sprite.node.physicsBody?.collisionBitMask = .min
        
        sprite.node.physicsBody?.velocity = CGVector(dx: direction, dy: 0) // Velocity going from right to left
        sprite.node.physicsBody?.linearDamping = 0 // Movement will not slow down over time
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        let boards = objects.compactMap {
            $0 as? Board
        }.sorted {
            $0.position.y < $1.position.y
        }
        boards.first?.hit()
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "Home")
    let navController = UINavigationController(rootViewController: vc)
    return navController
}

