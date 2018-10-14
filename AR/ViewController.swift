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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
//        sceneView.delegate = self
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
//        sceneView.autoenablesDefaultLighting = true
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration: ARConfiguration
        
        if ARWorldTrackingConfiguration.isSupported {
            configuration = ARWorldTrackingConfiguration()
        } else {
           configuration = AROrientationTrackingConfiguration()
        }
      
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
