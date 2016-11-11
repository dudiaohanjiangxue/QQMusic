//
//  QQMusicLrcCell.swift
//  QQMusic
//
//  Created by KC on 16/11/10.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQMusicLrcCell: UITableViewCell {
     ///歌词
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    ///歌词模型
    var musicLrcModel: QQMusicLrcModel? {
        didSet {
            
         lrcLabel.text = musicLrcModel?.lrcContent
        
        }
    
    }
    
    //当前这行歌词的进度
    var progress: CGFloat = 0 {
        didSet {
          lrcLabel.progressValue = progress
        }
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
