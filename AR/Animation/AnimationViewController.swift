//
//  AnimationViewController.swift
//  AR
//
//  Created by hyerikim on 13/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class AnimationViewController: UIViewController , ARSCNViewDelegate {

    @IBOutlet weak var SCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCNView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        SCNView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        SCNView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
