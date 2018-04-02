//
//  DSModal.swift
//  drink_shop
//
//  Created by Basel on 2018-04-02.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class DSModal: NSObject {
    func showModal(at frame: CGRect) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.blue
            print(frame.minX)
            view.frame = CGRect(x: frame.minX, y: frame.minY, width: 20, height: 20)
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: +140)
            })
            
        }
    }
}
