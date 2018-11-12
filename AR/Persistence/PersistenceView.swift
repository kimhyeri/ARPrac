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
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    // indicates whether it’s currently a good time to capture a world map
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            if ( virtualObjectAnchor != nil && frame.anchors.contains(virtualObjectAnchor!) ){
                print("좋음") }
        default:
            print("구림")
        }
        statusLabel.text = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
    }
    
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
       
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = SCNView
            .hitTest(sender.location(in: SCNView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Remove exisitng anchor and add new anchor
        if let existingAnchor = virtualObjectAnchor {
            SCNView.session.remove(anchor: existingAnchor)
        }
        
        addCube(at: hitTestResult)
        
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: hitTestResult.worldTransform)
    }
    
    func addCube(at: ARHitTestResult) {
        
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cube.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(at.worldTransform.columns.3.x, at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        node.geometry = cube
        SCNView.scene.rootNode.addChildNode(node)

    }
    
}
