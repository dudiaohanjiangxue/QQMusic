//
//  QQListTableViewController.swift
//  QQMusic
//
//  Created by KC on 16/11/8.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class QQListTableViewController: UITableViewController {

    
    //MARK: - 属性
    ///数据源
    var musicModels :[QQMusicModel] = [QQMusicModel]() {
        didSet {
        tableView.reloadData()
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.加载数据
         musicModels = QQDataTool.getMusicListData()
        //2.初始化界面
        setupUI()
    }

}

//MARK: -  UITableViewDataSource
extension QQListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicModels.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQListCell.cellForTableView(tableView: tableView) as! QQListCell
        cell.musicModel = musicModels[indexPath.row]
        cell.animation(type: .rotate)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicModel = musicModels[indexPath.row]
        QQMusicOperationTool.shared.playMusic(model: musicModel)
        //跳转到下一级
        self.performSegue(withIdentifier: "pushDetail", sender: nil)
    }
    
}
//MARK: - UI
extension QQListTableViewController {
    fileprivate func setupUI() {
        tableView.rowHeight = 60
        navigationController?.isNavigationBarHidden = true
         let bgImageView = UIImageView(frame: tableView.bounds)
        bgImageView.image = UIImage(named: "QQListBack.jpg")
         tableView.backgroundView = bgImageView
        tableView.separatorStyle = .none
    }


}
