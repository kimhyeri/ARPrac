//
//  BallViewController.swift
//  AR
//
//  Created by hyerikim on 30/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class BallViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var currentNode : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        addBack()
        
        registerGestureRecognizer()
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    
    @IBAction func startHorizontalAction(_ sender: Any) {

        horizontalAction(node: currentNode)
    }
    
    @IBAction func stopAllAction(_ sender: Any) {
    
        currentNode.removeAllActions()
    }
    
    @IBAction func startRoundAction(_ sender: Any) {
    
        roundAction(node: currentNode)
    }

}

extension BallViewController : ARSCNViewDelegate {
    
    func registerGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {

        //scene view to be accessed
        
        //access the point of view of the scene view center point
        
        //access sceneView
        guard let sceneView = gestureRecognizer.view as? ARSCNView else {
            return
        }
        
        guard let centerPoint = sceneView.pointOfView else {
            return
        }
        
        //transform matric
        
        let cameraTransform = centerPoint.transform
        let cameraLocation = SCNVector3(cameraTransform.m41, cameraTransform.m42, cameraTransform.m43)
        
        // camera orientation opposite
        let cameraOrientation = SCNVector3(-cameraTransform.m31, -cameraTransform.m32, -cameraTransform.m33)
        
        let cameraPostion = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y, cameraLocation.z + cameraOrientation.z)
        
        
        //create geometry
        //create material
        
        let basketball = SCNSphere(radius: 0.15)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "basketballSkin.png")
        basketball.materials = [material]
        
        
        let ballNode = SCNNode(geometry: basketball)
        ballNode.position = cameraPostion
        
        //create physicsShape and physicsBody
        
        let physicsShape = SCNPhysicsShape(node: ballNode, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        
        ballNode.physicsBody = physicsBody
        
        let forceVector: Float = 6
        
        ballNode.physicsBody?.applyForce(SCNVector3Make(cameraPostion.x * forceVector, cameraPostion.y * forceVector, cameraPostion.z * forceVector), asImpulse: true)
        
        
        sceneView.scene.rootNode.addChildNode(ballNode)
        
        
    }
    
    func horizontalAction(node: SCNNode) {
        
        //1m to the left and right
        
        let leftAction = SCNAction.move(by: SCNVector3(-1, 0, 0), duration: 3)
        
        let rightAction = SCNAction.move(by: SCNVector3(1, 0, 0), duration: 3)
        
        //create sequence
        
        let actionSequence = SCNAction.sequence([leftAction,rightAction])
        
        //run action
        node.runAction(SCNAction.repeat(actionSequence, count: 2))
        
        
    }
    
    func addBack() {
        guard let backScene = SCNScene(named: "art.scnassets/hoop.scn") else {
            return
        }
        
        guard let backNode = backScene.rootNode.childNode(withName: "backboard", recursively: false) else {
            return
        }
        
        backNode.position = SCNVector3(0, 0.5, -3)
        
        let physicsShape = SCNPhysicsShape(node: backNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        
        //static body ( do not move)
        let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        
        backNode.physicsBody = physicsBody
        
        sceneView.scene.rootNode.addChildNode(backNode)
                
        currentNode = backNode
        
    }

    
    func roundAction(node: SCNNode) {
        
        let upLeft = SCNAction.move(by: SCNVector3(1, 1, 0), duration: 2)
        
        let downRight = SCNAction.move(by: SCNVector3(1, -1, 0), duration: 2)
        
        let downLeft = SCNAction.move(by: SCNVector3(-1, -1, 0), duration: 2)
        
        let upRight = SCNAction.move(by: SCNVector3(-1, 1, 0), duration: 2)
        
        let actionSequence = SCNAction.sequence([upLeft,downLeft,downRight,upRight])
        
        node.runAction(SCNAction.repeat(actionSequence, count: 2))

    }
}
