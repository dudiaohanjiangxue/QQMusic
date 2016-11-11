//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
    //单例
    static let shared: QQMusicOperationTool = QQMusicOperationTool()
    //播放工具
    private lazy var tool: QQMusicTool = QQMusicTool()
    //播放列表
    var musicMList: [QQMusicModel]?
    //播放的模型
    private var musicMessageM: QQMusicMessageModel = QQMusicMessageModel()
    ///记录上一次的行号
    var lastRow = 0
    
    ///当前的索引
    var currentIndex:Int = 0 {
        didSet {
            if currentIndex < 0 {
                currentIndex = (musicMList?.count)! - 1
            }
            if currentIndex > (musicMList?.count)! - 1 {
                currentIndex = 0
            }
        
        }
    
    
    }
    
    //获取最新的数据
    func getMusicMessageM() -> QQMusicMessageModel {
        if musicMList == nil {
            return musicMessageM
        }
       // 需要在这里,保证数据模型的数据信息, 处于最新的状态
        musicMessageM.musicM = musicMList![currentIndex]
        musicMessageM.currentTime = (tool.player?.currentTime)!
        musicMessageM.totalTime = (tool.player?.duration)!
        musicMessageM.isPlaying = (tool.player?.isPlaying)!
       
         return musicMessageM
    }
    
    
    
    //播放音乐
    func playMusic(model: QQMusicModel) {
        tool.playMusic(model: model)
        
        guard let musicMList = musicMList else {
              print("没有播放列表, 只能播放单首歌曲")
            return
        }
        currentIndex = musicMList.index(of: model)!
    }
    
    //播放当前的音乐
    func playCurrentMusic() {
        tool.playCurrentMusic()
    }
    
    //暂停
    func puaseMusic() {
       tool.puaseCurrentMusic()
    }
    
    //上一首
    func preMusic() {
       currentIndex -= 1
        let model = musicMList![currentIndex]
        playMusic(model: model)
    }
    //下一首
    func nextMusic() {
        currentIndex += 1
        let model = musicMList![currentIndex]
        playMusic(model: model)
    }
    
    //设置当前时间
    func setCuurentTime(time: TimeInterval) {
        tool.setCurrentTime(time: time)
    }
    
    
}

extension QQMusicOperationTool {
   
   //设置锁屏的音乐播放界面
    func setupLockMessage() {
        let musicMessageModel = getMusicMessageM()
         let infoCenter = MPNowPlayingInfoCenter.default()
        
            var name = ""
            var singer = ""
        if musicMessageModel.musicM?.name != nil {
            
            name = (musicMessageModel.musicM?.name)!
        }
        if musicMessageModel.musicM?.singer != nil {
        
            singer = (musicMessageModel.musicM?.singer)!
        }
        
        var artwork: MPMediaItemArtwork?
        let imageName = musicMessageModel.musicM?.icon
        if imageName != nil {
        let image = UIImage(named: imageName!)
            if image != nil {
                let lrcMs = QQDataTool.getMusicLrc(lrcName: (musicMessageModel.musicM?.lrcname)!)
                
                let rowLrc = QQDataTool.getcurrentRowLrc(lrcModelS: lrcMs, currentTime: musicMessageModel.currentTime)
                
                if lastRow != rowLrc.row {
                    lastRow = rowLrc.row
                    let resultImage = QQImageTool.getImage(sourceImage: image!, text: rowLrc.LrcModel?.lrcContent)
                    print(resultImage)
                    artwork = MPMediaItemArtwork(image: resultImage)
                }
                
              
            
            }
        }
        
        
        let infoDic: NSMutableDictionary = NSMutableDictionary()
        infoDic.setValue(name, forKey: MPMediaItemPropertyAlbumTitle)
        infoDic.setValue(singer, forKey: MPMediaItemPropertyArtist)
        infoDic.setValue(musicMessageModel.totalTime, forKey: MPMediaItemPropertyPlaybackDuration)
        infoDic.setValue(musicMessageModel.currentTime, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        
        
        if artwork != nil {
            infoDic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
            let infoDic2 = infoDic.copy() as! [String : Any]
            
            //设置信息
            infoCenter.nowPlayingInfo = infoDic2
        }else {
          print("什么")
//           infoDic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
        }
        
       
        //接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    
    }
    
}
