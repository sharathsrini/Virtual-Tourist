//
//  VTLongPressGR.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/01/24.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//

import Foundation
import UIKit

class VTLongPressGR: UILongPressGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        self.minimumPressDuration = 1.0
        self.allowableMovement = 0.5
        
    }
    
}
