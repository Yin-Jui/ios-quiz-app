//
//  Line.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/24.
//

import CoreGraphics
import UIKit

class Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var color = UIColor.black
    
    init(begin:CGPoint, end:CGPoint) {
        self.begin = begin
        self.end = end
    }
}

