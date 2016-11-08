//
//  QQDataTool.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQDataTool: NSObject {
  
    class func getMusicListData() -> [QQMusicModel] {
       //1.获取资源路径
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            print("路劲不对")
            return [QQMusicModel]()
        }
        //转换模型
        guard let dictArray = NSArray(contentsOfFile: path) else {
             print("获取不了资源")
            return [QQMusicModel]()
        }
        var musicModels: [QQMusicModel] = [QQMusicModel]()
        for dict in dictArray {
            musicModels.append(QQMusicModel(dict: dict as! [String : Any]))
        }
        
        return musicModels
        
    }
    
    
}
