//
//  RulerViewController.swift
//  AR
//
//  Created by hyerikim on 22/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RulerViewController: UIViewController , ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //set ui touch
        if let touchLocation = touches.first?.location(in: sceneView) {
         
            let hitTestResult = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                addDot(at: hitResult)
            }
        }
        
    }
    
    //create new dot geometry
    func addDot(at hitResult : ARHitTestResult ) {

        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            cal()
        }
    
        
    }
    
    func cal () {
        //starting position
        let start = dotNodes[0]
        
        //end position
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        //거리 구하기 double = pow
        let distance = sqrt(
            pow(a, 2) + pow(b,2 ) + pow(c,2)
        )
        
        //절대값 distance never get negative
        print(abs(distance))
        
        //rendering 3d text
        updateText(text: "\(abs(distance))" , at: end.position)
        
        
        
    }
    
    func updateText(text: String, at: SCNVector3) {
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        let textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(at.x , at.y  + 0.01, at.z )
        
        //1percent original size
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.pause()
    }
}
