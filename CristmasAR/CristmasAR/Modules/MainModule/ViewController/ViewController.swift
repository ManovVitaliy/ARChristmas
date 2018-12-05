//
//  ViewController.swift
//  CristmasAR
//
//  Created by user on 11/13/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addTapGestureToSceneView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        // Run the view's session
        sceneView.session.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Touch Handlers
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapGesture(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let hitTestResult = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first
            else { return }
        let anchor = ARAnchor(transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
}

extension ViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else {
            return
        }
//        let tirTree = TirTreeNode.getTirTreeNode()
//        DispatchQueue.main.async {
//            node.addChildNode(tirTree!)
//        }
        let sphereNode = NewYearBallNode.getNewYearBallNode(color: UIColor.green, radius: 0.01)
        sphereNode.runAction(NewYearBallNode.changeColor)
        DispatchQueue.main.async {
            node.addChildNode(sphereNode)
        }
    }
}
