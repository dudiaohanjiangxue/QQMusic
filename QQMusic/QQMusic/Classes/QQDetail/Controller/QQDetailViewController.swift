//
//  QQDetailViewController.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQDetailViewController: UIViewController {

    
    //MARK: - 属性
    ///播放进度
    @IBOutlet weak var progressSlider: UISlider!
    ///滚动歌词
    @IBOutlet weak var lrcBackView: UIScrollView!
    ///单句歌词
    @IBOutlet weak var lrcLabel: UILabel!
    ///前面的图片
    @IBOutlet weak var foreImageView: UIImageView!
    ///背景模糊图片
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    lazy var lrcView: UIView = {
        let lrcView : UIView = UIView()
        lrcView.backgroundColor = UIColor.clear
        lrcView.frame = self.lrcBackView.bounds
        lrcView.frame.origin.x = self.lrcBackView.bounds.width
        return lrcView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lrcView)
        setupUI()
        
    }
 

}

//MARK: - UI
extension QQDetailViewController {
    fileprivate func setupUI() {
        //歌词
        lrcBackView.delegate = self
        lrcBackView.isPagingEnabled = true
        lrcBackView.showsHorizontalScrollIndicator = false
        lrcBackView.contentSize = CGSize(width: lrcBackView.bounds.width * 2, height: 0)
        
        //前面的图片
        foreImageView.layer.cornerRadius = foreImageView.bounds.width * 0.5
        foreImageView.layer.masksToBounds = true
        
        //进度条
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
    }


}

//MARK: - UIScrollViewDelegate
extension QQDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / scrollView.bounds.width
        foreImageView.alpha = alpha
        lrcView.alpha = alpha
    }


}
