//
//  ARKitExtensions.swift
//  CristmasAR
//
//  Created by user on 11/13/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import ARKit

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        let mat = SCNMatrix4(self)
        return SCNVector3(mat.m41, mat.m42, mat.m43)
    }
}

extension ARSession {
    func run() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
