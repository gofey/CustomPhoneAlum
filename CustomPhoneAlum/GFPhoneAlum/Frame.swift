//
//  File.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/15.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit

class Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let scale = UIScreen.main.scale
    
    static let logicScale = UIScreen.main.bounds.width / 375
    static let fk_width = CGFloat(375.0)
    static let fk_height = CGFloat(UIScreen.main.bounds.height / logicScale)
}
class ItemSize {
    static let width = (UIScreen.main.bounds.width - 25) / 4
    static let height =  (UIScreen.main.bounds.width - 25) / 4
}

