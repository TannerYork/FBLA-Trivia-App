//
//  CarnivalWheelSlice.swift
//  TTFortuneWheelSample
//
//  Created by Efraim Budusan on 11/1/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import Foundation
import TTFortuneWheel

public class CarnivalWheelSlice: FortuneWheelSliceProtocol {
    
    public enum Style {
        case brickRed
        case sandYellow
        case babyBlue
        case deepBlue
    }
    
    public var title: String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .brickRed: return UIColor(red:0.18, green:0.34, blue:0.38, alpha:1.0)
        case .sandYellow: return UIColor(red:0.94, green:0.74, blue:0.12, alpha:1.0)
        case .babyBlue: return UIColor(red:0.85, green:0.56, blue:0.22, alpha:1.0)
        case .deepBlue: return UIColor(red:0.24, green:0.56, blue:0.65, alpha:1.0)
        }
    }
    
    public var fontColor: UIColor {
        return UIColor.white
    }
    
    public var offsetFromExterior:CGFloat {
        return 10.0
    }
    
    public var font: UIFont {
        switch style {
        case .brickRed: return UIFont(name: "Chunkfive", size: 22.0)!
        case .sandYellow: return UIFont(name: "Lobster 1.3", size: 22.0)!
        case .babyBlue: return UIFont(name: "Phosphate", size: 22.0)!
        case .deepBlue: return UIFont(name: "Bebas", size: 22.0)!
        }
    }
    
    public var stroke: StrokeInfo? {
        return StrokeInfo(color: UIColor.white, width: 1.0)
    }
    
    public var style:Style = .brickRed
    
    public init(title:String) {
        self.title = title
    }
    
    public convenience init(title:String, degree:CGFloat) {
        self.init(title:title)
        self.degree = degree
    }
    
}
