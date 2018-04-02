//
//  DSModal.swift
//  drink_shop
//
//  Created by Basel on 2018-04-02.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class DSModal: NSObject {
    func showModal(at point: CGPoint) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.blue
            print(point.x)
            view.frame = CGRect(x: point.x, y: point.y, width: 20, height: 20)
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: -140)
            })
            
        }
    }
}
