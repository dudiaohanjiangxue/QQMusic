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
    //播放列表
    var musicMList: [QQMusicModel]?
    //播放的模型
    private var musicMessageM: QQMusicMessageModel = QQMusicMessageModel()
    
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
}
