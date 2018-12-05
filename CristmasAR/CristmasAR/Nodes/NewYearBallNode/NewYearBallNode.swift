//
//  NewYearBallNode.swift
//  CristmasAR
//
//  Created by user on 11/13/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import ARKit

class NewYearBallNode {
    class func getNewYearBallNode(color: UIColor, radius: CGFloat) -> SCNNode {
        let ballGeometry = SCNSphere(radius: radius)
        
        let ballNode = SCNNode()
        ballNode.geometry = ballGeometry
        ballNode.geometry?.materials.first?.lightingModel = .physicallyBased
        
        ballNode.geometry?.materials.first?.diffuse.contents = color
        ballNode.geometry?.materials.first?.metalness.contents = UIImage(named: "art.scnassets/Materials/NewYearBall/NewYearBall_M.png")
        ballNode.geometry?.materials.first?.shininess = 0.7
        ballNode.geometry?.materials.first?.lightingModel = .physicallyBased
        ballNode.geometry?.materials.first?.writesToDepthBuffer = false
        
        addHalo(toNode: ballNode, startRadius: radius)
        
        return ballNode
    }
    
    private static func addHalo(toNode: SCNNode, startRadius: CGFloat) {
        var rad: CGFloat = startRadius
        
        for _ in 0...9 {
            rad += startRadius / 5
            let sunHalo = SCNSphere(radius: rad)
            sunHalo.firstMaterial?.diffuse.contents = UIImage(named: "halo")
            sunHalo.firstMaterial?.emission.contents = UIImage(named: "halo")
            sunHalo.firstMaterial?.lightingModel = .constant
            sunHalo.firstMaterial?.writesToDepthBuffer = false
            
            let sunHaloNode = SCNNode()
            sunHaloNode.opacity = 0.4
            sunHaloNode.name = "sunImported"
            sunHaloNode.position = toNode.position
            sunHaloNode.geometry = sunHalo
            
            toNode.addChildNode(sunHaloNode)
        }
    }
    
    static let changeColor = SCNAction.repeatForever(SCNAction.customAction(duration: 12) { (node, elapsedTime) -> () in
        var percentage: CGFloat
        var color = UIColor.red
        
        // 4 colors
        let delta: CGFloat = 3.0
        
        switch Int(elapsedTime) {
        // yellow
        case 3, 4, 5:
            percentage = (elapsedTime - delta) / delta
            color = UIColor(red: 1 - percentage, green: 1 - percentage, blue: percentage, alpha: 1)
        // blue
        case 6, 7, 8:
            percentage = (elapsedTime - delta * 2) / delta
            color = UIColor(red: 0, green: percentage, blue: 1 - percentage, alpha: 1)
        // green
        case 9, 10, 11:
            percentage = (elapsedTime - delta * 3) / delta
            color = UIColor(red: percentage, green: 1 - percentage, blue: 0, alpha: 1)
        // red
        default:
            percentage = elapsedTime / delta
            color = UIColor(red: 1, green: percentage, blue: 0, alpha: 1)
        }
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.geometry?.firstMaterial?.emission.contents = color
        node.geometry?.firstMaterial?.emission.intensity = 0.2
        node.geometry?.firstMaterial?.lightingModel = .physicallyBased
        
        var opacity: CGFloat = 0.2
        for childNode in node.childNodes {
            opacity -= 0.02
            childNode.geometry?.firstMaterial?.diffuse.contents = color
            childNode.geometry?.firstMaterial?.diffuse.intensity = opacity
            childNode.opacity = opacity
            childNode.geometry?.firstMaterial?.emission.contents = color
            childNode.geometry?.firstMaterial?.emission.intensity = opacity
        }
    })
}
