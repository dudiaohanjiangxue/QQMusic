//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit
import AVFoundation
class QQMusicTool: NSObject {

    var player: AVAudioPlayer?
    
    func playMusic(model: QQMusicModel) {
      //1.获取音乐播放路径
        guard  let url = Bundle.main.url(forResource: model.filename, withExtension: nil) else {
            return
        }
        if player?.url == url {
         player?.play()
            return
        }
        do{
        
            player = try AVAudioPlayer(contentsOf: url)
        }catch {
          print(error)
            return
        }
        //准备播放
        player?.prepareToPlay()
        //播放
        player?.play()
    
    }
    
}
