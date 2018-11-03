//
//  DetailViewController.swift
//  AR
//
//  Created by hyerikim on 31/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import MultipeerConnectivity

class DetailViewController: UIViewController , ARSCNViewDelegate, ARSessionDelegate{

    @IBOutlet weak var SCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SCNView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        SCNView.session.run(configuration)
        
    }
    
}
