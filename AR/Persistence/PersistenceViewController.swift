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
    var worldMappingStatus: ARFrame.WorldMappingStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        
        // load one
        if mapDataFromFile != nil {

        }
    }
    
    override var shouldAutorotate: Bool {
        return false
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

        guard let sceneURL = Bundle.main.url(forResource: "ship", withExtension: "scn", subdirectory: "art.scnassets"), let referenceNode = SCNReferenceNode(url: sceneURL) else {
                fatalError("can't load virtual object")
        }
        referenceNode.load()

        return referenceNode
    }()
    
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
    func feedBack() {
        switch worldMappingStatus {
        case .extending?, .mapped?:
            print("좋음")
        default:
            print("구림")
        }
    }
    
}

//MARK: Persistence
extension PersistenceViewController {
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
    
    @objc func loadData() {
        print("load Data")
        /// - Tag: ReadWorldMap
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

            //snapshot image 뜨게
        } else {
            print("No snapshot image in world map")
        }
        // Remove the snapshot anchor from the world map since we do not need it in the scene.
        worldMap.anchors.removeAll(where: { $0 is SnapshotAnchor })

    }
}
