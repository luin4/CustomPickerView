//
//  UIView+extension.swift
//
//  Created by xxx on 2019/6/5.
//  Copyright © . All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    var x: CGFloat {
        set {self.frame.origin.x = newValue}
        get {return self.frame.origin.x}
    }
    
    var y: CGFloat {
        set {self.frame.origin.y = newValue}
        get {return self.frame.origin.y}
    }
    
    var width: CGFloat {
        set {self.frame.size.width = newValue}
        get {return self.frame.size.width}
    }
    
    var height: CGFloat {
        set {self.frame.size.height = newValue}
        get {return self.frame.size.height}
        
    }
    var right:CGFloat{
        
        set{
            var frame = self.frame
            frame.origin.x = newValue - frame.size.height
            self.frame = frame
        }
        get{return self.frame.origin.x + self.frame.size.width }
        
    }
    var bottom:CGFloat{
        set{
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get{return self.frame.origin.y + self.frame.size.height}
        
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
   
}

