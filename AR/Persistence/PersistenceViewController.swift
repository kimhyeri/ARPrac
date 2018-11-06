//
//  PersistenceViewController.swift
//  AR
//
//  Created by hyerikim on 06/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class PersistenceViewController: UIViewController , ARSCNViewDelegate , ARSessionDelegate {

    @IBOutlet weak var SCNView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        
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
        
        SCNView.session.delegate = self
        SCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        UIApplication.shared.isIdleTimerDisabled = true
        SCNView.session.run(configuration)
        
    }

}


//MARK: Setting View
extension PersistenceViewController {
    
    func setNavigationButton() {
        let saveRightBarButtonItem = UIBarButtonItem.init(title: "save", style: .done, target: self, action: #selector(PersistenceViewController.saveData))
        
        let loadRightBarButtonItem = UIBarButtonItem.init(title: "load", style: .done, target: self, action: #selector(PersistenceViewController.loadData))

        self.navigationItem.rightBarButtonItems = [saveRightBarButtonItem, loadRightBarButtonItem]
    }
    
    @objc func saveData() {
        print("save Data")
    }
    
    @objc func loadData() {
        print("load Data")
    }
    
    // tap gesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: SCNView) {
            
            let hitTestResult = SCNView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                updateText(text: "혜리", at: hitResult)
                
            }
        }
    }
    
    func updateText(text: String, at: ARHitTestResult) {
        
        let textGeometry = SCNText(string: "\(text)", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(at.worldTransform.columns.3.x , at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        SCNView.scene.rootNode.addChildNode(textNode)
    }

}



//MARK: Persistence
extension PersistenceViewController {
    
}
