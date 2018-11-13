//
//  AnimationView.swift
//  AR
//
//  Created by hyerikim on 13/11/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

extension AnimationViewController {
    
    func setNavaitionButton() {
        
        let boxButtonItem = UIBarButtonItem.init(title: "box", style: .done, target: self, action: #selector(AnimationViewController.selectBox))
        
        let sphereButtonItem = UIBarButtonItem.init(title: "sphere", style: .done, target: self, action: #selector(AnimationViewController.selectSphere))
        
        let tubeButtonItem = UIBarButtonItem.init(title: "tube", style: .done, target: self, action: #selector(AnimationViewController.selectTube))
        
        self.navigationItem.rightBarButtonItems = [boxButtonItem, sphereButtonItem, tubeButtonItem]

    }
    
    //get geometry position
    func getGeometry(position: SCNVector3) {
        
        if let shape = selectShape {
            shape.position = position
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.gray
            shape.geometry?.materials = [material]
            
            SCNView.scene.rootNode.addChildNode(shape)
            
        }
        
    }
    
}

// Get geometry node
extension AnimationViewController {
    
    @objc func selectBox() {
        selectShape = SCNNode(geometry: SCNBox(width: 0.2,
                                               height: 0.2,
                                               length: 0.2,
                                               chamferRadius: 0))
        
    }
    
    @objc func selectSphere() {
        selectShape = SCNNode(geometry: SCNSphere(radius: 0.2 / 2))

    }
    
    @objc func selectTube() {
        selectShape = SCNNode(geometry: SCNTube(innerRadius: 0.2 / 10,
                                                outerRadius: 0.2 / 8,
                                                height: 0.2))
        if let selectShape = selectShape {
            selectShape.eulerAngles = SCNVector3(0, 0, Double.pi / 2)
        }
        
    }
    
}
