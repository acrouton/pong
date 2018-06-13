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
    
    var x: Int = Int(arc4random_uniform(2))
    var difficulty: Double = 1.3
    var gamePaused: Bool = false
    var vel: Int = 0
    var vX: CGFloat = 0
    var vY: CGFloat = 0
    
    func myRandomNumber(sign: Int) -> Int {
        let num: Int = (Int(arc4random_uniform(11))+10)
        if sign == 0 {
            return (-num)
        }
        return num
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    var pause = SKSpriteNode()
    
    var score = [Int]()
    
    var points = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        startGame()
        
        points = self.childNode(withName: "points") as! SKLabelNode
       
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        player = self.childNode(withName: "player") as! SKSpriteNode
        pause = self.childNode(withName: "pause") as! SKSpriteNode
        
        vel = myRandomNumber(sign: x)
        ball.physicsBody?.applyImpulse(CGVector(dx: vel, dy: abs(vel)))
        
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
        x = Int(arc4random_uniform(2))
        vel = myRandomNumber(sign: x)
        if winner == player {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: vel, dy: abs(vel)))
        }
        else {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: vel, dy: -vel))
        }
        points.text = "\(score[1]) | \(score[0])"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            
            let xDist: CGFloat = (pause.position.x - loc.x)
            let yDist: CGFloat = (pause.position.y - loc.y)
            if sqrt((xDist*xDist) + (yDist*yDist)) <= 21 {
                if gamePaused == false {
                    vX = (ball.physicsBody?.velocity.dx)!
                    vY = (ball.physicsBody?.velocity.dy)!
                    gamePaused = true
                    ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
                else {
                    gamePaused = false
                    ball.physicsBody?.velocity = CGVector(dx: vX, dy: vY)
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let loc = touch.location(in: self)
            if gamePaused == false {
                player.run(SKAction.moveTo(x: loc.x, duration: 0.2))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gamePaused == false {
            if ball.position.y > 0 {
                enemy.run(SKAction.moveTo(x: ball.position.x, duration: difficulty))
            }
            
            if ball.position.y <= player.position.y - 70 {
                addScore(winner: enemy)
            }
            else if ball.position.y >= enemy.position.y + 70 {
                addScore(winner: player)
            }
        }
    }
}
