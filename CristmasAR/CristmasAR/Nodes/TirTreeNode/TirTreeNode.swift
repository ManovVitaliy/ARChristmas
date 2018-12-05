//
//  TirTreeNode.swift
//  CristmasAR
//
//  Created by user on 11/13/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import ARKit

class TirTreeNode {
    class func getTirTreeNode() -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/Models/TirTree/TirTree.obj")!
        
        guard let node = scene.rootNode.childNodes.first else {
            return nil
        }
        for material in (node.geometry?.materials)! {
            material.diffuse.contents = UIImage(named: "art.scnassets/Materials/TirTree/TirTree_D.jpg")
        }
        
        return node
    }
}
