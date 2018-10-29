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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        addBack()
    }
    
    
    func addBack() {
        guard let backScene = SCNScene(named: "art.scnassets/hoop.scn") else {
            return
        }
        
        guard let backNode = backScene.rootNode.childNode(withName: "backboard", recursively: false) else {
            return
        }
        
        backNode.position = SCNVector3(0, 0.5, -3)
        
        sceneView.scene.rootNode.addChildNode(backNode)
        
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
    
}

extension BallViewController : ARSCNViewDelegate {
    
}
