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
    @IBOutlet weak var showHideInfoViewButton: UIButton!
    @IBOutlet weak var showHideInfoViewButtonBottomConstraint: NSLayoutConstraint!
    
    //MARK: - properties
    
    var infoView: ShowHideView?
    
    //MARK: - viewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
        addTapGestureToSceneView()
        setupUIAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        sceneView.session.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupUIAppearance() {
        setupCustomCollectionView()
    }
    
    private func setupCustomCollectionView() {
        infoView = ShowHideView.init(superview: self.view)
        infoView?.customCollectionView.delegate = self
        infoView?.customCollectionView.dataSource = self
        infoView?.customCollectionView.reloadData()
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
    
    @objc func showView(_ sender: Any) {
        if(infoView?.isHide == false){
            infoView?.toggleView(0, superView: self.view)
            self.showHideInfoViewButtonBottomConstraint.constant = 20
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.infoView?.toggleView(1, superView: self.view)
            self.showHideInfoViewButtonBottomConstraint.constant = -(self.infoView?.viewTopAnchor!.constant)! + 20
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - actions
    @IBAction func showHideInfoViewButtonTapped(_ sender: UIButton) {
        showView(sender)
    }
    
    @IBAction func removePreviousNodeButtonTapped(_ sender: UIButton) {
        if let anchor = sceneView?.session.currentFrame?.anchors.last {
            sceneView?.session.remove(anchor: anchor)
            let lastNode = sceneView.scene.rootNode.childNodes.last
            lastNode?.removeFromParentNode()
        }
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
        let sphereNode = NewYearBallNode.getNewYearBallNode(color: UIColor.green, radius: 0.05)
        sphereNode.runAction(NewYearBallNode.changeColor)
        DispatchQueue.main.async {
            node.addChildNode(sphereNode)
        }
    }
}

extension ViewController: CustomCollectionViewDelegate {
    func didSelectItem(index: Int) {
        print(index)
    }
}

extension ViewController: CustomCollectionViewDataSource {
    func numberOfItemsInSection() -> Int {
        return 4
    }
    
    func cellForItem(index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.red
        
        return view
    }
}
