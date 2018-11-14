//
//  ARViewController.swift
//  AR
//
//  Created by hyerikim on 26/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ARViewController: UIViewController {

    @IBOutlet weak var ARSCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ARSCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        let sphere = SCNSphere(radius: 0.2)
        
        let material  =  SCNMaterial()
        
        material.diffuse.contents = UIImage(named: "art.scnassets/river.jpeg")
        
        sphere.materials = [material]
        
        let node = SCNNode()
        
        //3 성분 벡터의 표현
        node.position = SCNVector3(0.5, 0.5, -0.5)
        
        //object display assign
        node.geometry = sphere
        
        ARSCNView.scene.rootNode.addChildNode(node)
        ARSCNView.autoenablesDefaultLighting = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARSCNView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        ARSCNView.session.run(configuration)
    }
    
}
