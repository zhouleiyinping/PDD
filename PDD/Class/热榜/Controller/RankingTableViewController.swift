//
//  RankingTableViewController.swift
//  PDD
//
//  Created by 周磊 on 16/3/18.
//  Copyright © 2016年 ZL. All rights reserved.
//

import UIKit

class RankingTableViewController: UITableViewController,hotListRequestDataDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    var parameter:String?
    var dataSouce = [HotListModel]()
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    let hotListRequest = HotListRequestData()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=UIColor.whiteColor()
        
        tableView.registerClass(HotListTableViewCell.self, forCellReuseIdentifier: "HotListTableViewCell")
        
        let headerView = UIView(frame:CGRectMake(0, 0, ScreenWidth, 5))

        headerView.backgroundColor = BgColor
                
        tableView!.tableHeaderView = headerView;
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        hotListRequest.delegate = self
        self.showHUD()
        hotListRequest.requestData(parameter!)
      
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        header.lastUpdatedTimeLabel!.hidden = true
        header.stateLabel!.hidden = true
        tableView.mj_header = header
        
    }
    
    // 顶部刷新
    func headerRefresh(){
        
       hotListRequest.requestData(parameter!)
        
    }
    
    func hotListRequest(goods_listArray:NSArray) {
        
        self.hideHUD()
        // 结束刷新
        tableView.mj_header.endRefreshing()
        
        dataSouce.removeAll()
        
        dataSouce = goods_listArray as! [HotListModel]
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSouce.count
    }

    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var hotList = HotListModel()
        hotList = dataSouce[indexPath.row]
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("HotListTableViewCell", forIndexPath: indexPath) as! HotListTableViewCell
    
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.releaseData(hotList, index: "\(indexPath.row+1)")
        
        return cell
        
    }
 
    override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 150
    }
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        
        let emptyViewGound = UIView(frame: CGRectMake(0,0,ScreenWidth,ScreenHeight))
        emptyViewGound.backgroundColor = UIColor.whiteColor()
        return emptyViewGound
        
    }
    
    
}
