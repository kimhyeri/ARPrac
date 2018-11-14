//
//  ScanningViewController.swift
//  AR
//
//  Created by hyerikim on 14/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit

class ScanningViewController: UIViewController {

    @IBOutlet var SCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCNView.delegate = self
        SCNView.debugOptions = [.showFeaturePoints, .showWorldOrigin]

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Bottle", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.detectionObjects = referenceObjects
        SCNView.session.run(configuration)
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SCNView.session.pause()
    }
}

//MARK -  SCNView Delegate method

extension ScanningViewController : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            print(objectAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            let sphere = SCNSphere(radius: 0.2)
            sphere.firstMaterial?.diffuse.contents = UIColor.red
            node.position = SCNVector3(0.1, 0.1, 0.1)
            node.addChildNode(planeNode)

        }
        
        return node
    }
    
}
