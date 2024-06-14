//
//  GameScene.swift
//  JuicyTarget
//
//  Created by Rodrigo Cavalcanti on 12/06/24.
//

import SpriteKit

class GameScene: SKScene {
    var title: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    var backgrounds: [SKSpriteNode] = []
    var lifePoints = 3
    var hearts: [Heart] = []
    var gameTimer: Timer?
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var scoreLabel: SKLabelNode!
    var gameOver = false {
        didSet {
            changeCurtains(gameOver)
        }
    }
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        setupBackgroundLayers()
        setupScore()
        setupLifePoints()
        setupTitle()
        playBackgroundMusic()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let unreachableNodes = children
            .compactMap {
                if let board = $0 as? Board {
                    return board.node
                }
                return nil
            }
        
        unreachableNodes.filter {
            $0.position.x > 1500 || $0.position.x < -1500
        }.forEach {
            $0.parent?.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if gameOver {
            restartGame()
            return
        }
        
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        let boards = objects.compactMap {
            $0 as? Board
        }.sorted {
            $0.position.y < $1.position.y
        }
        boards.first?.hit()
        if boards.first?.name == "good" {
            score += 1
            run(SKAction.playSoundFileNamed("correct.caf", waitForCompletion: false))
        } else if boards.first?.name == "bad" {
            if lifePoints > 0 {
                lifePoints -= 1
                if lifePoints >= 0 {
                    hearts[lifePoints].shrink()
                }
                run(SKAction.playSoundFileNamed("incorrect.caf", waitForCompletion: false))
            } else {
                endGame()
                run(SKAction.playSoundFileNamed("end.caf", waitForCompletion: true))
            }
        }
    }
}

// MARK: - Main Layout Nodes
extension GameScene {
    func setupBackgroundLayers() {
        for i in 0...4 {
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
            
            if i == 1 || i == 2 {
                background.jiggle(duration: 1.5 + Double(i))
            }
            if i == 4 {
                background.alpha = 0
            }
        }
    }
    
    func setupScore() {
        let scoreIcon = SKSpriteNode(imageNamed: "basket")
        scoreIcon.position = CGPoint(x: 1020, y: 90)
        scoreIcon.zPosition = 4
        addChild(scoreIcon)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "0"
        scoreLabel.fontSize = 90
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: 900, y: 60)
        addChild(scoreLabel)
    }
    
    func setupTitle() {
        let scoreIcon = SKSpriteNode(imageNamed: "title")
        scoreIcon.position = CGPoint(x: size.width / 2, y: 700)
        scoreIcon.setScale(0.7)
        scoreIcon.zPosition = 4
        addChild(scoreIcon)
    }
    
    func setupLifePoints() {
        for xPosition in [100, 150, 200] {
            let heart = Heart()
            heart.configure(at: CGPoint(x: xPosition, y: 90))
            heart.zPosition = 4
            addChild(heart)
            hearts.append(heart)
        }
    }
    
    func changeCurtains(_ closingIt: Bool) {
        let fadeAnimation = SKAction.fadeAlpha(to: closingIt ? 1 : 0, duration: 0.5)
        backgrounds.last?.run(fadeAnimation)
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "bossanova", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
}

// MARK: - Game Loop
extension GameScene {
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
    
    func endGame() {
        gameOver = true
        gameTimer?.invalidate()
        children.compactMap {
            $0 as? Board
        }.forEach {
            $0.removeFromParent()
        }
    }
    
    func restartGame() {
        gameOver = false
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
        lifePoints = 3
        hearts.forEach {
            $0.shrink(reverse: true)
        }
        score = 0
    }
}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "Home")
    let navController = UINavigationController(rootViewController: vc)
    return navController
}

