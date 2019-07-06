//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let ball = SKShapeNode(circleOfRadius: 30)
let box = SKShapeNode(rectOf: .init(width: 300, height: 50), cornerRadius: 10)

ball.physicsBody = SKPhysicsBody(edgeChainFrom: ball.path!)
box.physicsBody = SKPhysicsBody(edgeChainFrom: box.path!)

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let scene = SKScene()

scene.backgroundColor = .blue

// Set the scale mode to scale to fit the window
scene.scaleMode = .resizeFill

sceneView.showsPhysics = true

// Present the scene
sceneView.presentScene(scene)

scene.anchorPoint = .init(x: 0.5, y: 0.5)

scene.addChild(box)
scene.addChild(ball)

ball.fillColor = .orange
box.fillColor = .purple

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

ball.position.x -= 180
ball.position.y -= 50

ball.physicsBody?.accessibilityPath?.cgPath
