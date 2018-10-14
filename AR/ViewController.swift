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
        sceneView.delegate = self
        
        
        //radius = 모서리 10cm 10cm 10cm
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        //color red assign
        let material  =  SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        cube.materials = [material]
        
        //point 3d space
        let node = SCNNode()
        
        node.position = SCNVector3(0, 0.1, -0.5)
        
        //object display assign
        node.geometry = cube
        
        
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        print(ARWorldTrackingConfiguration.isSupported)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
