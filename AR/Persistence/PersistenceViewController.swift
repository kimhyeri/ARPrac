//
//  PersistenceViewController.swift
//  AR
//
//  Created by hyerikim on 05/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PersistenceViewController: UIViewController , ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var SCNView: ARSCNView!
    
    private var textNode = SCNNode()

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
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device.")
        }
        
        let configuration  = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        SCNView.session.delegate = self
        SCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        SCNView.session.run(configuration)
        
    }
    
    func setNaviButton() {
        let saveRightBarButtonItem = UIBarButtonItem.init(title: "save", style: .done, target: self, action: #selector(PersistenceViewController.saveData))
        self.navigationItem.rightBarButtonItem = saveRightBarButtonItem
        
        let loadRightBarButtonItem = UIBarButtonItem.init(title: "load", style: .done, target: self, action: #selector(PersistenceViewController.loadData))
        self.navigationItem.rightBarButtonItem = loadRightBarButtonItem
    }
    
    //filemanager에 저장
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
}

//MARK: Persistence
extension PersistenceViewController {

    //filemanager map 저장하기
    
    @objc func saveData() {
        print("saving Data")

    }
    
    //filemanager map 불러오기

    @objc func loadData() {
        
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
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(at.worldTransform.columns.3.x , at.worldTransform.columns.3.y, at.worldTransform.columns.3.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        SCNView.scene.rootNode.addChildNode(textNode)
    }
    
}
