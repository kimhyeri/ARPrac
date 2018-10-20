//
//  ViewController.swift
//  AR
//
//  Created by hyerikim on 14/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Set the view's delegate
        sceneView.delegate = self
//
//        //radius = 모서리 10cm 10cm 10cm
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let sphere = SCNSphere(radius: 0.2)
        // color red assign
        // 지오메트리 표면의 모양을 정의하는 음영 속성의 집합
//        let material  =  SCNMaterial()
//
////        material.diffuse.contents = UIColor.red
//        material.diffuse.contents = UIImage(named: "art.scnassets/river.jpeg")
//
//        sphere.materials = [material]
//
//        //point 3d space
//        //3D 좌표 공간에서 위치와 변형을 나태내는 장면 그래프의 구조
//        let node = SCNNode()
//
//        //3 성분 벡터의 표현
//        node.position = SCNVector3(0, 0.1, -0.5)
//
//        //object display assign
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(0, 0, -0.1)
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
//        if ARWorldTrackingConfiguration.isSupported {
//            let configuration = ARWorldTrackingConfiguration()
//            configuration.planeDetection = .horizontal
//        }
//        else {
//           configuration = AROrientationTrackingConfiguration()
//        }
        
        sceneView.session.run(configuration)
    }
    
    //anchor : 타일
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            
            //conver dimension anchor
            //dont put y at with
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.x)
            
            //rotate 90 degree
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode){
        
        let randoX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randoZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randoX * 5), y: 0, z:CGFloat( randoZ * 5), duration: 0.5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            //2d to 3d
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitReuslt = results.first {
                addDice(location: hitReuslt)
            }
        }
    }
    
    func addDice(location: ARHitTestResult) {
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                location.worldTransform.columns.3.z
            )
            
            diceArray.append(diceNode)
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
            
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        rollAll()
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        
        if !diceArray.isEmpty {
            for i in diceArray {
                i.removeFromParentNode()
            }
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }


}