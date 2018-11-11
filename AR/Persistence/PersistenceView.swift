//
//  PersistenceView.swift
//  AR
//
//  Created by hyerikim on 12/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation
import ARKit
import SceneKit


//MARK: Setting View
extension PersistenceViewController {
    
    func setNavigationButton() {
        let saveRightBarButtonItem = UIBarButtonItem.init(title: "save", style: .done, target: self, action: #selector(PersistenceViewController.saveData))
        
        let loadRightBarButtonItem = UIBarButtonItem.init(title: "load", style: .done, target: self, action: #selector(PersistenceViewController.loadData))
        
        self.navigationItem.rightBarButtonItems = [saveRightBarButtonItem, loadRightBarButtonItem]
    }
    
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    // tap gesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: SCNView) {
            
            let hitTestResult = SCNView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                updateText(text: "혜리", at: hitResult)
                //                putShip(at: hitResult)
            }
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    func putShip (at: ARHitTestResult) {
        
        // Remove exisitng anchor and add new anchor
        if let existingAnchor = virtualObjectAnchor {
            SCNView.session.remove(anchor: existingAnchor)
        }
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: at.worldTransform)
        SCNView.session.add(anchor: virtualObjectAnchor!)
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        SCNView.scene = scene
        
    }
    
    func updateText(text: String, at: ARHitTestResult) {
        
        // Remove exisitng anchor and add new anchor
        if let existingAnchor = virtualObjectAnchor {
            SCNView.session.remove(anchor: existingAnchor)
        }
        
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: at.worldTransform)
        SCNView.session.add(anchor: virtualObjectAnchor!)
        
        let textGeometry = SCNText(string: "\(text)", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(at.worldTransform.columns.3.x , at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        SCNView.scene.rootNode.addChildNode(textNode)
        
    }
    
    // indicates whether it’s currently a good time to capture a world map
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            print("좋음")
        default:
            print("구림")
        }
        statusLabel.text = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
    }
    
}
