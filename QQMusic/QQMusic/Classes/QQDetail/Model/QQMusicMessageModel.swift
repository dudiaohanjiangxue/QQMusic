//
//  QQMusicMessageModel.swift
//  QQMusic
//
//  Created by KC on 16/11/9.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

    var musicM: QQMusicModel?
    
    var currentTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var isPlaying: Bool = false
    //当前的播放时间
    var currentTimeFormat: String {
        get {
        
        return QQTimeTool.getFormatTime(time: currentTime)
        }
    
    }
    
    //总得时间
    var totalTimeFormat: String {
        get {
        
        return QQTimeTool.getFormatTime(time: totalTime)
        }
    
    }
}
