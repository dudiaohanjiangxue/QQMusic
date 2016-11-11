//
//  QQTimeTool.swift
//  QQMusic
//
//  Created by KC on 16/11/9.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {
   
    
    class func getFormatTime(time: TimeInterval) -> String {
       let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    
    }
    
    class func getTime(formarTime: String) -> TimeInterval {
       let minSec = formarTime.components(separatedBy: ":")
        if  minSec.count == 2 {
            let min = Double(minSec[0])
            let sec = Double(minSec[1])
            return min! * 60 + sec!
        }
      return 0
    
    }
}
