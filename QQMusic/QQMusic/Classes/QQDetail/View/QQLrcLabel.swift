//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by KC on 16/11/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var progressValue: CGFloat = 0 {
        didSet {
            
        setNeedsDisplay()
        
        }
    
    }
    
    override func draw(_ rect: CGRect) {
       super.draw(rect)
        UIColor.green.set()
        /*
         case normal
         
         case multiply
         
         case screen
         
         case overlay
         
         case darken
         
         case lighten
         
         case colorDodge
         
         case colorBurn
         
         case softLight
         
         case hardLight
         
         case difference
         
         case exclusion
         
         case hue
         
         case saturation
         
         case color
         
         case luminosity

        case clear /* R = 0 */  从左到右进行隐藏
        
        case copy /* R = S */  从左到右进行上色,颜色慢慢遮盖内容
        
        case sourceIn /* R = S*Da */ 只有文字从左往右上色
        
        case sourceOut /* R = S*(1 - Da) */ 只有文字背景从左往右上色, 文字还是原来的颜色
        
        case sourceAtop /* R = S*Da + D*(1 - Sa) */
        
        case destinationOver /* R = S*(1 - Da) + D */
        
        case destinationIn /* R = D*Sa */
        
        case destinationOut /* R = D*(1 - Sa) */
        
        case destinationAtop /* R = S*(1 - Da) + D*Sa */
        
        case xor /* R = S*(1 - Da) + D*(1 - Sa) */
        
        case plusDarker /* R = MAX(0, (1 - D) + (1 - S)) */
        
        case plusLighter /* R = MIN(1, S + D) */
  */
        UIRectFillUsingBlendMode(CGRect(x: 0, y: 0, width: rect.width * progressValue, height: rect.height), .sourceIn)
        
    }
   

}
