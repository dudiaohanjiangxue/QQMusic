 //
//  QQLrcViewController.swift
//  QQMusic
//
//  Created by KC on 16/11/9.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

private let cellID = "cellID"
class QQLrcViewController: UITableViewController {

    //MARK: - 属性
    ///所有的歌词
    var lrcModels: [QQMusicLrcModel] = [QQMusicLrcModel]() {
        didSet {
        tableView.reloadData()
        
        }
    
    }
    ///当前行
    var scrollRow: Int = -1 {
        didSet {
           
            if scrollRow == oldValue {
                return
            }
             tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
            tableView.scrollToRow(at: IndexPath(row: scrollRow, section: 0), at: .middle, animated: true)
        }
        
    }
    
    //当前这行歌词的进度
    var progress:CGFloat = -1 {
        didSet {
          let cell = tableView(tableView, cellForRowAt: IndexPath(row: scrollRow, section: 0)) as! QQMusicLrcCell
            cell.progress = progress
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        print(QQMusicLrcCell.self)
        tableView.register(UINib(nibName: String(describing: QQMusicLrcCell.self), bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: tableView.bounds.height * 0.5, left: 0, bottom: tableView.bounds.height * 0.5, right: 0)
    }

 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lrcModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lrcModel = lrcModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! QQMusicLrcCell
        cell.musicLrcModel = lrcModel
        if indexPath.row == scrollRow {
            cell.progress = progress
        }else {
            cell.progress = 0
        }
        return cell
    }


}
