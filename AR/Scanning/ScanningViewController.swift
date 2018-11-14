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

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var SCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCNView.delegate = self
        SCNView.debugOptions = [.showFeaturePoints]

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        //.arobjc 추가해줘야함. Bottle ar group폴더에
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Bottle", bundle: Bundle.main) else {
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

extension ScanningViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            
            print(objectAnchor)
            infoLabel.text = "detect"
            
            let sphere = SCNSphere(radius: 0.2)
            
            sphere.firstMaterial?.diffuse.contents = UIColor.red
            node.position = SCNVector3(objectAnchor.transform.columns.3.x,
                                       objectAnchor.transform.columns.3.y,
                                       objectAnchor.transform.columns.3.z)
            node.geometry = sphere
            infoLabel.text = "detect"
            
            SCNView.scene.rootNode.addChildNode(node)
            
        }
    }
    
}
