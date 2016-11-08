//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQMusicOperationTool: NSObject {
    //单例
    static let shared: QQMusicOperationTool = QQMusicOperationTool()
    //播放工具
    private lazy var tool: QQMusicTool = QQMusicTool()
    
    //播放音乐
    func playMusic(model: QQMusicModel) {
    tool.playMusic(model: model)
    
    }
}
