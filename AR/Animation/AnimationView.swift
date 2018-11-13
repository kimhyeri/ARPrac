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
    
    func getGeometry(shape : Shape, position: SCNVector3) {
        
        let selectShape : SCNNode!
        
        switch shape {
        case .box:
            selectShape = SCNNode(geometry: SCNBox(width: 0.2,
                                             height: 0.2,
                                             length: 0.2,
                                             chamferRadius: 0))
 
        case .sphere:
            selectShape = SCNNode(geometry: SCNSphere(radius: 0.2 / 2))
       
        case .tube:
            selectShape = SCNNode(geometry: SCNTube(innerRadius: 0.2 / 10,
                                              outerRadius: 0.2 / 8,
                                              height: 0.2))
            selectShape.eulerAngles = SCNVector3(0, 0, Double.pi / 2)
        }
        
        selectShape.position = position
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.gray
        selectShape.geometry?.materials = [material]
        
        SCNView.scene.rootNode.addChildNode(selectShape)
        
    }
    
}
