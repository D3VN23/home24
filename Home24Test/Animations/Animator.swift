//
//  Animator.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/5/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import UIKit

class Animator {
    class func performBounceAnimation<T: UIView>(for object: T) {
        UIView.animate(withDuration: 0.15, animations: {
            object.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                object.transform = CGAffineTransform.identity
            }
        })
    }
    
    class func performFadeIn<T: UIView>(for object: T) {
        UIView.animate(withDuration: 0.1) {
            object.alpha = 1.0
        }
    }
    
    class func performFadeOut<T: UIView>(for object: T) {
        UIView.animate(withDuration: 0.1) {
            object.alpha = 0.0
        }
    }
}
