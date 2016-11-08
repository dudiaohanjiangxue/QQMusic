//
//  QQMusicModel.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    ///歌名
    var name: String?
    //歌曲的文件名
    var filename: String?
    //歌词的文件名
    var lrcname: String?
    //歌手的名字
    var singer: String?
    //歌手头像
    var singerIcon: String?
    //背景图片
    var icon: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
