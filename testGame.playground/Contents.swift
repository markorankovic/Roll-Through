

import SpriteKit
import GameplayKit
import PlaygroundSupport

let view = SKView(frame: CGRect(origin: CGPoint(), size: CGSize(width: 500, height: 500)))
PlaygroundPage.current.liveView = view

class ShapeComponent: GKComponent {
    
    var shapeNode: SKShapeNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(shapeNode: SKShapeNode) {
        super.init()
        self.shapeNode = shapeNode
    }
    
}

class Ball: GKEntity {
    
    var power: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(radius: CGFloat, fillColor: UIColor) {
        super.init()
        let shapeNode = SKShapeNode(ellipseOf: .init(width: radius * 2, height: radius * 2))
        let powerBar = SKShapeNode(rectOf: .init(width: 0, height: 10))
        powerBar.position.y = radius + 20
        powerBar.name = "power-bar"
        shapeNode.addChild(powerBar)
        powerBar.strokeColor = .red
        powerBar.lineWidth = 0
        shapeNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        shapeNode.physicsBody?.restitution = 0.4
        shapeNode.strokeColor = .black
        shapeNode.fillColor = fillColor
        addComponent(ShapeComponent(shapeNode: shapeNode))
    }

}

class Block: GKEntity {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(size: CGSize, fillColor: UIColor) {
        super.init()
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.physicsBody = SKPhysicsBody(edgeLoopFrom: .init(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        shapeNode.strokeColor = .black
        shapeNode.fillColor = fillColor
        addComponent(ShapeComponent(shapeNode: shapeNode))
    }

}
 
class EnitityManager {
    
    var entities = Set<GKEntity>()
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        if let shape = entity.component(ofType: ShapeComponent.self)?.shapeNode {
            scene.addChild(shape)
        }
    }
    
    func remove(entity: GKEntity) {
        entities.remove(entity)
        if let shape = entity.component(ofType: ShapeComponent.self)?.shapeNode {
            shape.removeFromParent()
        }
    }
    
}

class GameState: GKState {
    
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
}

extension CGPoint {

    func hypot2(point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }

}

class WaitingState: GameState {
    
    var clickedOnBall = false
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return PauseState.self == stateClass || ShootingState.self == stateClass
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            clickedOnBall = (touches.first!.location(in: scene).hypot2(point: ballNode.position)) <= (ballNode.path!.boundingBox.size.width) / 2
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clickedOnBall {
            if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
                ballNode.physicsBody?.velocity.dx = scene.ball.power
                clickedOnBall = false
                scene.ball.power = 0
                stateMachine?.enter(ShootingState.self)
            }
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        print("Entered waiting")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if clickedOnBall {
            scene.ball.power += 50
            if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
                if let powerBar = ballNode.children.first as? SKShapeNode {
                    powerBar.lineWidth += 1
                }
            }
            print("Power: \(scene.ball.power)")
        }
    }
    
}

class ReturnState: GameState {
    
    var ballNotMoving: Bool {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            return ballNode.physicsBody!.isResting
        }
        return false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == WaitingState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            ballNode.zRotation = 0
        }
        print("Entered return")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if ballNotMoving {
            stateMachine?.enter(WaitingState.self)
        }
    }

}
 
class ShootingState: GameState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ReturnState.self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            ballNode.physicsBody?.velocity = .init()
            ballNode.physicsBody?.angularVelocity = .init()
            ballNode.position = .init()
        }
        stateMachine?.enter(ReturnState.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        if let ballNode = scene.ball.component(ofType: ShapeComponent.self)?.shapeNode {
            if let powerBar = ballNode.children.first as? SKShapeNode {
                powerBar.lineWidth = 0
            }
        }
        print("Entered shooting")
    }
    
}

class PauseState: GameState {
    
    var previousState: GKState?
    
    override func didEnter(from previousState: GKState?) {
        print("Entered pause")
        self.previousState = previousState
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene.nodes(at: touches.first!.location(in: scene)).first?.name == "togglePauseButton" {
            if let state = previousState {
                stateMachine?.enter(type(of: state))
            }
        }
    }

}

class GameScene: SKScene {
    
    var entityManager: EnitityManager!
    var stateMachine: GKStateMachine!
    
    let ball = Ball(radius: 50, fillColor: .brown)
    let fixedBlock = Block(size: CGSize(width: 200, height: 50), fillColor: .red)
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        entityManager = EnitityManager(scene: self)
         
        entityManager.add(entity: ball)
        
        let fixedBlockShapeNode = fixedBlock.component(ofType: ShapeComponent.self)!.shapeNode!
        fixedBlockShapeNode.position.y = -200
        fixedBlockShapeNode.physicsBody?.affectedByGravity = false 
        entityManager.add(entity: fixedBlock)
        
        stateMachine = GKStateMachine(states: [
            WaitingState(scene: self),
            ShootingState(scene: self),
            ReturnState(scene: self),
            PauseState(scene: self),
        ])
        stateMachine.enter(ReturnState.self)
    }
    
} 

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesBegan(touches, with: event)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesMoved(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentGameState = stateMachine.currentState as? GameState {
            currentGameState.touchesEnded(touches, with: event)
        }
    }
}

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        stateMachine.currentState?.update(deltaTime: currentTime) 
    }
}

let scene = GameScene(size: view.bounds.size)
scene.anchorPoint = .init(x: 0.5, y: 0.5)
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: .init(x: -scene.size.width / 2, y: -scene.size.height / 2, width: scene.size.width, height: scene.size.height))
view.presentScene(scene)


