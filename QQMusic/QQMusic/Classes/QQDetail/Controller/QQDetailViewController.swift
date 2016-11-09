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
    ///背景模糊图片
    @IBOutlet weak var backgroundImageView: UIImageView!
    //歌名
    @IBOutlet weak var songNameLabel: UILabel!
    ///歌手名
    @IBOutlet weak var singerNameLabel: UILabel!
    
    ///滚动歌词
    @IBOutlet weak var lrcBackView: UIScrollView!
    ///单句歌词
    @IBOutlet weak var lrcLabel: UILabel!
    ///前面的图片
    @IBOutlet weak var foreImageView: UIImageView!
    
    
    ///播放进度
    @IBOutlet weak var progressSlider: UISlider!
     ///当前播放的时间
    @IBOutlet weak var currentTimeLabel: UILabel!
    ///歌曲总的时间
    @IBOutlet weak var totalTimeLabel: UILabel!
    /**播放或暂停按钮*/
    @IBOutlet weak var playOrPuaseBtn: UIButton!
    ///歌词
    lazy var lrcView: UIView = {
        let lrcView : UIView = UIView()
        lrcView.backgroundColor = UIColor.clear
        lrcView.frame = self.lrcBackView.bounds
        lrcView.frame.origin.x = self.lrcBackView.bounds.width
        return lrcView
    }()
    
    /**定时器*/
    var updateTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lrcView)
        setupUI()
        updateOne()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupUIFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    
   

}

//MARK: - UI
extension QQDetailViewController {
    fileprivate func setupUI() {
        //歌词
        lrcBackView.delegate = self
        lrcBackView.isPagingEnabled = true
        lrcBackView.showsHorizontalScrollIndicator = false
        
        
        //进度条
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
        
    }

    
    fileprivate func setupUIFrame() {
    
        lrcBackView.contentSize = CGSize(width: lrcBackView.bounds.width * 2, height: 0)
        
        //前面的图片
        foreImageView.layer.cornerRadius = foreImageView.bounds.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    

}

//MARK: - 定时器
extension QQDetailViewController {
    
    fileprivate func addTimer() {
         updateTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimes), userInfo: nil, repeats: true)
        
        RunLoop.current.add(updateTimer!, forMode: .commonModes)
    
    }
    
    fileprivate func removeTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    
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

//MARK: - 点击事件
extension QQDetailViewController {
     ///1.关闭控制器
    @IBAction func close(_ sender: Any) {
      let _ =  navigationController?.popViewController(animated: true)
    }
    
    ///上一首
    @IBAction func preMusic(_ sender: Any) {
        QQMusicOperationTool.shared.preMusic()
        updateOne()
    }
    
    ///暂停或者播放
    @IBAction func playOrPause(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {//播放
            print("播放")
            QQMusicOperationTool.shared.playCurrentMusic()
            resumeRotationAnimation()
        }else {//暂停
            QQMusicOperationTool.shared.puaseMusic()
            pauseRotationAnimation()
           print("暂停")
        }
    }
    ///下一首
    @IBAction func nextMusic(_ sender: Any) {
        QQMusicOperationTool.shared.nextMusic()
        updateOne()
    }

    //只需要设置一次的信息
    fileprivate func updateOne() {
        let musicMessageModel = QQMusicOperationTool.shared.getMusicMessageM()
      backgroundImageView.image = UIImage(named: (musicMessageModel.musicM?.icon)!)
        songNameLabel.text = musicMessageModel.musicM?.name
        singerNameLabel.text = musicMessageModel.musicM?.singer
        totalTimeLabel.text = musicMessageModel.totalTimeFormat
        foreImageView.image =  UIImage(named: (musicMessageModel.musicM?.icon)!)
       addRotationAnimation()
        if musicMessageModel.isPlaying {
            resumeRotationAnimation()
        }else {
            pauseRotationAnimation()
        }
    }
    
    //需要多次设置的信息
   @objc fileprivate func UpdateTimes() {
    let musicMessageModel = QQMusicOperationTool.shared.getMusicMessageM()
      progressSlider.value = Float(musicMessageModel.currentTime / musicMessageModel.totalTime)
     currentTimeLabel.text = musicMessageModel.currentTimeFormat
    playOrPuaseBtn.isSelected = musicMessageModel.isPlaying
    //歌词
//     lrcLabel.text = nil
    
    }
}

extension QQDetailViewController {
    //添加动画
    func addRotationAnimation() {
        foreImageView.layer.removeAnimation(forKey: "rotate")
       let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        foreImageView.layer.add(animation, forKey: "rotate")
    
    }
    
    //暂停动画
    func pauseRotationAnimation() {
        
        foreImageView.layer.pauseAnimation()
    }
    
    //恢复动画
    func resumeRotationAnimation() {
        
        foreImageView.layer.resumeAnimation()
    }
}
