//
//  QQListCell.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit


enum AnimationType: Int {
    case rotate
    case scale
}

class QQListCell: UITableViewCell {

    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var singNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    //MARK: - 属性
    var musicModel: QQMusicModel? {
        didSet {
            guard let musicModel = musicModel else {
                return
            }
        iconImageV.image = UIImage(named: musicModel.icon!)
        singNameLabel.text = musicModel.name
        singerNameLabel.text = musicModel.singer
        
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageV.layer.cornerRadius = 25
        ;iconImageV.layer.masksToBounds = true
    }
    
    

}


extension QQListCell {
    //加载cell
    class func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQListCell
        if  cell == nil {
            cell = Bundle.main.loadNibNamed("QQListCell", owner: nil, options: nil)?.first as? QQListCell
        }
        cell?.backgroundColor = UIColor.clear
        return cell!
        
    }
    
    ///cell的动画
    func animation(type: AnimationType)  {
        switch type {
        case .rotate:
          //transform.rotation.x
            self.layer.removeAnimation(forKey: "roatation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
            animation.values = [-1/4 * M_PI, 0, 1/4 * M_PI, 0]
            animation.duration = 0.5
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "roatation")
        case .scale:
            //transform.scale
            self.layer.removeAnimation(forKey: "scale")
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.5
            scaleAnimation.toValue = 1
            scaleAnimation.duration = 1
            scaleAnimation.repeatCount = 1
            self.layer.add(scaleAnimation, forKey: "scale")
        }
    }

}
