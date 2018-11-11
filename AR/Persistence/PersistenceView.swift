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
        
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = SCNView
            .hitTest((touches.first?.location(in: SCNView))!, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // get only one 
        if let existingAnchor = virtualObjectAnchor {
            SCNView.session.remove(anchor: existingAnchor)
        }
        
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: hitTestResult.worldTransform)
        SCNView.session.add(anchor: virtualObjectAnchor!)

    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
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
