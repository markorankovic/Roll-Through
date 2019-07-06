//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    let ball1 = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100))
    let ball2 = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100))
    
    let meeting = SKShapeNode(ellipseOf: CGSize(width: 500, height: 500))
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .init(dx: 0, dy: -5)
        
        ball1.name = "ball1"
        ball2.name = "ball2"
        meeting.name = "meeting"
        
        ball1.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball2.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        meeting.physicsBody = SKPhysicsBody(edgeLoopFrom: meeting.path!)
        
        ball1.physicsBody?.isDynamic = false
        ball2.physicsBody?.isDynamic = false
        
        ball1.physicsBody?.affectedByGravity = false
        ball2.physicsBody?.affectedByGravity = false
        meeting.physicsBody?.affectedByGravity = false

        addChild(ball1)
        addChild(ball2)
        addChild(meeting)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball1.position = CGPoint(x: -100, y: 0)
        ball2.position = CGPoint(x: 100, y: 0)
        
        ball1.physicsBody?.affectedByGravity = true
        ball2.physicsBody?.affectedByGravity = true
        
        ball1.physicsBody?.velocity = .init(dx: 0, dy: 0)
        ball2.physicsBody?.velocity = .init(dx: 0, dy: 0)
        
        let groundCategory: UInt32 = 1
        let ballCategory: UInt32 = 2
        let ballContactCategory: UInt32 = 4
        
        ball1.physicsBody?.categoryBitMask = groundCategory | ballContactCategory
        ball1.physicsBody?.collisionBitMask = ballCategory
        ball1.physicsBody?.contactTestBitMask = ballCategory
        
        ball2.physicsBody?.categoryBitMask = groundCategory
        ball2.physicsBody?.collisionBitMask = ballCategory
        ball2.physicsBody?.contactTestBitMask = ballContactCategory
        
        meeting.physicsBody?.categoryBitMask = ballCategory
        meeting.physicsBody?.collisionBitMask = groundCategory
        meeting.physicsBody?.contactTestBitMask = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        print(ball1.physicsBody!.allContactedBodies().filter({ $0.node?.name! != "meeting" }))
    }
    
}

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = GameScene()

scene.scaleMode = .resizeFill

scene.anchorPoint = .init(x: 0.5, y: 0.5)

// Present the scene
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
