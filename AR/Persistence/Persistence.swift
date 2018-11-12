//
//  Persistence.swift
//  AR
//
//  Created by hyerikim on 12/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

//MARK: Persistence

extension PersistenceViewController {
    
    
    //stop scnview session run
    @objc func stopRunning() {
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        SCNView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        isRelocalizingMap = false
        virtualObjectAnchor = nil
        
        self.imageView.image = nil
    }
    
    //save snapshot
    @objc func saveData() {
        
        print("save Data")
        SCNView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else { return }
            
            // Add a snapshot image indicating where the map was captured.
            guard let snapshotAnchor = SnapshotAnchor(capturing: self.SCNView)
                else { fatalError("Can't take snapshot") }
            map.anchors.append(snapshotAnchor)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.mapSaveURL, options: [.atomic])
                DispatchQueue.main.async {
                    
                }
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
    // load snapshot
    @objc func loadData() {
        print("load Data")
        
        let worldMap: ARWorldMap = {
            guard let data = mapDataFromFile
                else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                    else { fatalError("No ARWorldMap in archive.") }
                return worldMap
            } catch {
                fatalError("Can't unarchive ARWorldMap from file data: \(error)")
            }
        }()
        
        // Display the snapshot image stored in the world map to aid user in relocalizing.
        if let snapshotData = worldMap.snapshotAnchor?.imageData,
            let snapshot = UIImage(data: snapshotData) {
            self.imageView.image = snapshot
        } else {
            print("No snapshot image in world map")
        }
        
        // Remove the snapshot anchor from the world map since we do not need it in the scene.
        worldMap.anchors.removeAll(where: { $0 is SnapshotAnchor })
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.initialWorldMap = worldMap
        SCNView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        isRelocalizingMap = true
        virtualObjectAnchor = nil
    }
    
}
