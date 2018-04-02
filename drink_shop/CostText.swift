//
//  CostText.swift
//  drink_shop
//
//  Created by Basel on 2018-04-02.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class CostText: NSAttributedString {
    override init(string: String, attributes: [NSAttributedStringKey: Any]?) {
        super.init(string: string, attributes: attributes)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
