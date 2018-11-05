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

class DetailViewController: UIViewController , ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var SCNView: ARSCNView!
    
    private var multipeerSession: MultipeerSession!
    private var textNode = SCNNode()
    private var mapProvider: MCPeerID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviButton()
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
        
        SCNView.session.delegate = self
        
        SCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        UIApplication.shared.isIdleTimerDisabled = true
        SCNView.session.run(configuration)

    }
    
    //MARK: - Update view
    
    // tap gesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: SCNView) {
            
            let hitTestResult = SCNView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResult.first {
                updateText(text: "혜리", at: hitResult)
                
            }
        }
    }
    
    func setNaviButton() {
        let rightBarButtonItem = UIBarButtonItem.init(title: "전송", style: .done, target: self, action: #selector(DetailViewController.sendData))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func updateText(text: String, at: ARHitTestResult) {
        
        let textGeometry = SCNText(string: "\(text)", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(at.worldTransform.columns.3.x , at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        SCNView.scene.rootNode.addChildNode(textNode)
    }
    
}


//MARK: Seding data to peers

extension DetailViewController {
    
    @objc func sendData() {
        print("sending data")
        
        SCNView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
        
    }
    
}

//MARK: Recieve data from peers
// Recieve and relocalize to the shared map

extension DetailViewController {
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
