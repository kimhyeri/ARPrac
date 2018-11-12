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
    
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    func setNavigationButton() {
        let saveRightBarButtonItem = UIBarButtonItem.init(title: "save", style: .done, target: self, action: #selector(PersistenceViewController.saveData))
        
        let loadRightBarButtonItem = UIBarButtonItem.init(title: "load", style: .done, target: self, action: #selector(PersistenceViewController.loadData))
        
        let stopBarButtonItem = UIBarButtonItem.init(title: "stop", style: .done, target: self, action: #selector(PersistenceViewController.stopRunning))
        
        self.navigationItem.rightBarButtonItems = [saveRightBarButtonItem, loadRightBarButtonItem, stopBarButtonItem]
    }
    
    // indicates whether it’s currently a good time to capture a world map
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            if ( virtualObjectAnchor != nil && frame.anchors.contains(virtualObjectAnchor!) ){
                print("좋음") }
        default:
            self.navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        statusLabel.text = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
    }
    
    //Tap recognize
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
       
        if isRelocalizingMap && virtualObjectAnchor == nil {
            return
        }
        
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = SCNView
            .hitTest(sender.location(in: SCNView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Remove exisitng anchor and add new anchor
        if let existingAnchor = virtualObjectAnchor {
            SCNView.session.remove(anchor: existingAnchor)
        }
        
        virtualObjectAnchor = ARAnchor(name: virtualObjectAnchorName, transform: hitTestResult.worldTransform)
        SCNView.session.add(anchor: virtualObjectAnchor!)
        
    }
    
}
