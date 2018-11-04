//
//  DetailViewController.swift
//  AR
//
//  Created by hyerikim on 31/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import MultipeerConnectivity

class DetailViewController: UIViewController , ARSCNViewDelegate, ARSessionDelegate{

    @IBOutlet weak var SCNView: ARSCNView!
    
    var multipeerSession: MultipeerSession!
    var textNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SCNView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)

        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
    
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        SCNView.session.delegate = self
        
        SCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        SCNView.session.run(configuration)

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //set ui touch
        if let touchLocation = touches.first?.location(in: SCNView) {
            
            let hitTestResult = SCNView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                updateText(text: "혜리", at: hitResult)
                
            }
        }
        
    }
    
    
    func updateText(text: String, at: ARHitTestResult) {
        
        let textGeometry = SCNText(string: "\(text)", extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(at.worldTransform.columns.3.x , at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        
        //1percent original size
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        SCNView.scene.rootNode.addChildNode(textNode)
    }
    

    var mapProvider: MCPeerID?

    func receivedData(_ data: Data, from peer: MCPeerID) {
        
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                SCNView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
            }
            else
                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                    // Add anchor to the session, ARSCNView delegate adds visible content.
                    SCNView.session.add(anchor: anchor)
                }
                else {
                    print("unknown data recieved from \(peer)")
            }
        } catch {
            print("can't decode data recieved from \(peer)")
        }
    }
    
}
