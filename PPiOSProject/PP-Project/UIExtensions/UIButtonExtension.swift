//
//  UIButtonExtension.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/6/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    @objc func pulse() {
        let pulseVar = CASpringAnimation(keyPath: "transform.scale")
        
        pulseVar.duration = 0.5
        pulseVar.fromValue = 0.8
        pulseVar.toValue = 1.0
        pulseVar.initialVelocity = 0.1
        pulseVar.damping = 1.5
        
        layer.add(pulseVar, forKey:nil)
    }
    
}
