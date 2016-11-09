//
//  CALayerAnimation.swift
//  QQMusic
//
//  Created by KC on 16/11/9.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

extension CALayer {
   //暂停动画
    func pauseAnimation() {
        let pauseTime: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    
    }
    
    //恢复动画
    func resumeAnimation() {
    
        let pausedTime: CFTimeInterval = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }


}
