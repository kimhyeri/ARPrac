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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var isRelocalizingMap = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
    
    }

    // Lock the orientation of the app to the orientation in which it is launched
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Session pause
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SCNView.session.pause()
    }
    
    // Set default configuration and run session
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        SCNView.delegate = self
        SCNView.session.delegate = self
        SCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        UIApplication.shared.isIdleTimerDisabled = true
        SCNView.autoenablesDefaultLighting = true
        SCNView.session.run(configuration)
    }

    // Access filemanager world map
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    var virtualObjectAnchor: ARAnchor?
    let virtualObjectAnchorName = "virtualObject"
    
    var virtualObject: SCNNode = {
        
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cube.materials = [material]
        let node = SCNNode()
        node.geometry = cube

        return node
    }()
    
    // Restore AR Content 
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor.name == virtualObjectAnchorName
            else { return }
        
        // save the reference to the virtual object anchor when the anchor is added from relocalizing
        if virtualObjectAnchor == nil {
            virtualObjectAnchor = anchor
        }
        
        node.addChildNode(virtualObject)

    }
}

