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
    @IBOutlet weak var lrcLabel: QQLrcLabel!
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
    ///占位视图
    lazy var lrcView: UIView = {
        let lrcView : UIView = UIView()
        lrcView.backgroundColor = UIColor.clear
        lrcView.frame = self.lrcBackView.bounds
        lrcView.frame.origin.x = self.lrcBackView.bounds.width
        return lrcView
    }()
    
    ///显示歌词控制器
    lazy var lrcVC: QQLrcViewController = QQLrcViewController()
    
    /**定时器*/
    var updateTimer: Timer?
    
    /**刷屏器*/
    var displayLink: CADisplayLink?
    
    
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
        addDisplayLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisplayLink()
    }
    
    deinit {
        print("销毁")
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
        
        //歌词
        lrcBackView.addSubview(lrcVC.tableView)
    }

    
    fileprivate func setupUIFrame() {
    
        lrcBackView.contentSize = CGSize(width: lrcBackView.bounds.width * 2, height: 0)
        
        //前面的图片
        foreImageView.layer.cornerRadius = foreImageView.bounds.width * 0.5
        foreImageView.layer.masksToBounds = true
        //歌词
        lrcVC.tableView.frame = lrcBackView.bounds
        lrcVC.tableView.frame.origin.x = lrcBackView.bounds.width
        
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
    
    fileprivate func addDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrcVCShowRowLrc))
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
    
    }
  
    fileprivate func removeDisplayLink() {
       displayLink?.invalidate()
       displayLink = nil
    }
}

//MARK: - UIScrollViewDelegate
extension QQDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / scrollView.bounds.width
        foreImageView.alpha = alpha
        lrcLabel.alpha = alpha
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
    
    @IBAction func down(_ sender: Any) {
        removeTimer()
    }
    
    @IBAction func up(_ sender: UISlider) {
        let musicMessageM = QQMusicOperationTool.shared.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
         QQMusicOperationTool.shared.setCuurentTime(time: currentTime)
        addTimer()
    }
    
    @IBAction func change(_ sender: UISlider) {
        let musicMessageM = QQMusicOperationTool.shared.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        
        currentTimeLabel.text = QQTimeTool.getFormatTime(time: currentTime)
    }
    
    

    //只需要设置一次的信息
    fileprivate func updateOne() {
        //设置数据
        let musicMessageModel = QQMusicOperationTool.shared.getMusicMessageM()
      backgroundImageView.image = UIImage(named: (musicMessageModel.musicM?.icon)!)
        songNameLabel.text = musicMessageModel.musicM?.name
        singerNameLabel.text = musicMessageModel.musicM?.singer
        totalTimeLabel.text = musicMessageModel.totalTimeFormat
        foreImageView.image =  UIImage(named: (musicMessageModel.musicM?.icon)!)
        //添加动画
         addRotationAnimation()
        if musicMessageModel.isPlaying {
            resumeRotationAnimation()
        }else {
            pauseRotationAnimation()
        }
        //更新歌词
        guard let musicM = musicMessageModel.musicM else {
            return
        }
        let lrcMs = QQDataTool.getMusicLrc(lrcName: musicM.lrcname!)
        lrcVC.lrcModels = lrcMs
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
    
    
    //更新歌词
    @objc fileprivate func updateLrcVCShowRowLrc() {
    
        let musicMessageModel = QQMusicOperationTool.shared.getMusicMessageM()
        let rowLrcM = QQDataTool.getcurrentRowLrc(lrcModelS: lrcVC.lrcModels, currentTime: musicMessageModel.currentTime)
        lrcVC.scrollRow = rowLrcM.row
        //当前的歌词
        lrcLabel.text = rowLrcM.LrcModel?.lrcContent
        
        if rowLrcM.LrcModel != nil {
            let progressTime = CGFloat(musicMessageModel.currentTime - rowLrcM.LrcModel!.startTime)
            let totalTime = CGFloat(rowLrcM.LrcModel!.endTime - rowLrcM.LrcModel!.startTime)
           
           let value = progressTime / totalTime
            lrcLabel.progressValue = value
            lrcVC.progress = value
        }
        
        //更新锁屏播放界面
            QQMusicOperationTool.shared.setupLockMessage()
    
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

//MARK: - 监听锁屏的界面操作
extension QQDetailViewController {

    override func remoteControlReceived(with event: UIEvent?) {
        switch (event?.subtype)! {
        case .remoteControlPlay:
            print("播放")
            QQMusicOperationTool.shared.playCurrentMusic()
        case .remoteControlPause:
             print("暂停")
             QQMusicOperationTool.shared.puaseMusic()

        case .remoteControlNextTrack:
             print("下一首")
            QQMusicOperationTool.shared.nextMusic()

        case .remoteControlPreviousTrack:
            print("上一首")
             QQMusicOperationTool.shared.preMusic()
        default:
            print("none")
        }
         updateOne()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        QQMusicOperationTool.shared.nextMusic()
        updateOne()
    }

}
