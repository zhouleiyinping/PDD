//
//  OverseasViewController.swift
//  PDD
//
//  Created by 周磊 on 16/3/15.
//  Copyright © 2016年 ZL. All rights reserved.
//

import UIKit

class OverseasViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,haiTaoRequestDataDelegate,ClickCollectionCallbackDelegate,HomeHeaderDelegate {
    
    var tableView:UITableView?
    var homeHeaderView = HomeHeaderView()
    var dataArray = [HaiTaoDataModel]()
    var countryArray = [HomeRollModel]()
    var promotionArray = [HomeRollModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = BgColor
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView!.registerClass(HomeMainTableViewCell.self, forCellReuseIdentifier:"HomeMainTableViewCell")
        tableView!.registerClass(HomeFirstTableViewCell.self, forCellReuseIdentifier:"HomeFirstTableViewCell")
        tableView?.registerClass(HomeAdTableViewCell.self, forCellReuseIdentifier: "HomeAdTableViewCell")
        tableView?.registerClass(HaiTaoCountryTableViewCell.self, forCellReuseIdentifier: "HaiTaoCountryTableViewCell")

        homeHeaderView = HomeHeaderView(frame: CGRectMake(0, 0, ScreenWidth, 200))
        homeHeaderView.delegate = self
        tableView!.tableHeaderView = homeHeaderView;
        view.addSubview(tableView!)

        let haiTaorequset = HaiTaoRequest()
        haiTaorequset.delegate = self
        self.showHUD()
        haiTaorequset.haiTaoRequest()
    
    }
    
    
    func haiTapRequest(haiTaoTotalArray:NSArray,promotionData:[HomeRollModel],countryData:[HomeRollModel]) {
        
        self.hideHUD()
        dataArray = haiTaoTotalArray as! [HaiTaoDataModel]
        promotionArray = promotionData
        countryArray = countryData
        homeHeaderView.reloadData(promotionArray)
        tableView?.reloadData()
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var haiTao = HaiTaoDataModel()
        haiTao = dataArray[indexPath.row]
        
        switch haiTao.cellType {
        case .group:
            
            let  cell = tableView.dequeueReusableCellWithIdentifier("HaiTaoCountryTableViewCell", forIndexPath: indexPath) as! HaiTaoCountryTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = BgColor
            cell.releaseData(countryArray)
            return cell
            
            
        case .common:
            
            let  cell = tableView.dequeueReusableCellWithIdentifier("HomeMainTableViewCell", forIndexPath: indexPath) as! HomeMainTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = BgColor
            cell.releaseData(haiTao.good_list)
            
            return cell
            
        default:
            
            
            let  cell = tableView.dequeueReusableCellWithIdentifier("HomeAdTableViewCell", forIndexPath: indexPath) as! HomeAdTableViewCell
            cell.backgroundColor = BgColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.releaseHomeAdData(haiTao.home_recommend, homeRecommend: haiTao.home_recommend.goodsList)
            cell.delegate = self
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var haitao = HaiTaoDataModel()
        haitao = dataArray[indexPath.row]
        
        switch haitao.cellType {
        case .group:
            return 100
        case .common:
            let  height=haitao.good_list.goods_name!.stringHeightWith(15,width:(ScreenWidth-20))
            return (180 + 85 + height)
                        
        default:
            return 280
        }
    }
    
    // MARK: - 中间广告点击事件
    func requestResult(home_recommend_goodlist:home_recommend_goodlistModel) {
        
        print(home_recommend_goodlist.goods_name)
        
    }
    // MARK: - 滚动图片点击事件
    func homeHeaderRequestResult(homeRollData:HomeRollModel) {
        
        print(homeRollData.subject)
    }
}

