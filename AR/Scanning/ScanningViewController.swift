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
        SCNView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SCNView.session.pause()
    }
}

extension ScanningViewController : ARSCNViewDelegate {
    
}
