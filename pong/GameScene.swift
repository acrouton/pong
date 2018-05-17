//
//  GameScene.swift
//  pong
//
//  Created by Andrew Craeton on 5/16/18.
//  Copyright © 2018 acraeton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var difficulty: Double = 0.25
    var velocity: Int = Int(arc4random_uniform(6)+10)
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    
    var score = [Int]()
    
    var points = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        startGame()
        
        points = self.childNode(withName: "points") as! SKLabelNode
       
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: velocity))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
    }
    
    func startGame() {
        score = [0, 0]
        points.text = "\(score[1]) | \(score[0])"
        
    }
    
    func addScore(winner: SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let vel = Int(arc4random_uniform(6)+10)
        if winner == player {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: vel, dy: vel))
        }
        else {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -vel, dy: -vel))
        }
        points.text = "\(score[1]) | \(score[0])"
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let loc = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: loc.x, duration: 0.2))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: difficulty))
        
        if ball.position.y <= player.position.y - 70 {
            addScore(winner: enemy)
        }
        else if ball.position.y >= enemy.position.y + 70 {
            addScore(winner: player)
        }
    }
}
