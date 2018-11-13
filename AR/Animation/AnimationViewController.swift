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

class AnimationViewController: UIViewController {

    @IBOutlet weak var SCNView: ARSCNView!
    
    var selectShape : SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCNView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        SCNView.delegate = self
        setNavaitionButton()
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


// MARK: - SCNView Delegate

extension AnimationViewController : ARSCNViewDelegate {
    
    //called everytime
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
      
        guard let viewPoint = SCNView.pointOfView else { return }
        
        let transform = viewPoint.transform
        //transform의 3번째 column
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        //transform의 4번째 column
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)

        let position = addSCNVector3(left: orientation, right: location)
        
        DispatchQueue.main.async {
            
            let rotateAction = SCNAction.rotate(by: 2 * .pi,
                                                around: SCNVector3(0, 1, 0),
                                                duration: 2)
            let rotateForeverAction = SCNAction.repeatForever(rotateAction)
            self.selectShape?.runAction(rotateForeverAction)
            
        }
        getGeometry(position: position)
        
    }
}

// SCNVector3 + SCNVector3
func addSCNVector3 (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x,
                      left.y + right.y,
                      left.z + right.z)
}
