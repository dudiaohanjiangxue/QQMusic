//
//  QQDataTool.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQDataTool: NSObject {
  ///获取歌曲的资料
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
    
    
    ///获取歌词资料
    class func getMusicLrc(lrcName: String) -> [QQMusicLrcModel] {
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return [QQMusicLrcModel]()
        }
        var lrcContent: String?
        do{
            lrcContent = try String(contentsOfFile: path)
        }catch {
            
           print(error)
            return [QQMusicLrcModel]()
        }
        if  lrcContent == nil {
            return [QQMusicLrcModel]()
        }
        
        //解析歌词 [02:36.84]只是因为在人群中多看了你一眼
        var lrcMs = [QQMusicLrcModel]()
        let lrcStrArray = lrcContent!.components(separatedBy: "\n")
        for lrcStr in lrcStrArray {
            if lrcStr.contains("[ti:") || lrcStr.contains("[ar:") || lrcStr.contains("[al:") {
            continue
            }
            let resultStr = lrcStr.replacingOccurrences(of: "[", with: "")
            let timeAndLrc = resultStr.components(separatedBy: "]")
            if timeAndLrc.count == 2 {
                let timeFormat = timeAndLrc[0]
                let lrc = timeAndLrc[1]
                let lrcMusicModel = QQMusicLrcModel()
                lrcMusicModel.startTime = QQTimeTool.getTime(formarTime: timeFormat)
                lrcMusicModel.lrcContent = lrc
                lrcMs.append(lrcMusicModel)
            }
        }
      
        for index in 0..<lrcMs.count {
            if index == lrcMs.count - 1 {
            
            break
            }
            lrcMs[index].endTime = lrcMs[index + 1].startTime
        }
         return lrcMs
    }
    
    ///获取当前行的歌词
    class func getcurrentRowLrc(lrcModelS: [QQMusicLrcModel], currentTime: TimeInterval) -> (row: Int, LrcModel: QQMusicLrcModel?) {
        for (index, lrcM) in lrcModelS.enumerated() {
            if  currentTime >= lrcM.startTime && currentTime <= lrcM.endTime {
                return (index, lrcM)
            }
        }
        return (0, nil)
    
    }
    
}
