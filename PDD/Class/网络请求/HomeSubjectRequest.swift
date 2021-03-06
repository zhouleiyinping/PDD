//
//  HomeSubjectRequest.swift
//  PDD
//
//  Created by 周磊 on 16/3/28.
//  Copyright © 2016年 ZL. All rights reserved.
//  首页、海淘滚动广告数据请求

import UIKit

class HomeSubjectRequest: NSObject {
    
    weak var delegate:homeSubjectDataDelegate?
    
    func homeSubjectRequest(subjectId:String){
        
        let url = "http://apiv2.yangkeduo.com/v2/subject/\(subjectId)/goods"
        
        request.defaultInstance().GetRequest(url).responseJSON { response in
            
            switch response.result {
            case .Success:
                
                guard let JsonData = response.result.value else { return }

                let goods_list = JsonData["goods_list"] as? NSArray
                
                var goods_listArray = [HomeModel]()
                
                for  goods_list_dict in goods_list! {
                    
                    let homeSubject = HomeModel()
                    homeSubject.mapping(goods_list_dict as! Dictionary<String, AnyObject>)
                    goods_listArray.append(homeSubject)
                }
                self.delegate?.homeSubjectRequest(goods_listArray)
                
            case .Failure(let error):
                
                print(error)
            }
        }
    }
    
    
    func countryGoodsListRequest(subjectId:String,blockPicture:(picture:String)->Void){
        
        let url = "http://apiv2.yangkeduo.com/subject/\(subjectId)"

        request.defaultInstance().GetRequest(url).responseJSON { response in
            
            switch response.result {
            case .Success:
                
                guard let JsonData = response.result.value else { return }
                
                let goods_list = JsonData["banner"] as! String

                blockPicture(picture: goods_list)
                
            case .Failure(let error):
                
                print(error)
            }
        }
        
    }

    
    func StoreInformationRequest(mallId:String) {
        
         //http://apiv2.yangkeduo.com/v2/mall/548/goods
        
            let url = "http://apiv2.yangkeduo.com/v2/mall/\(mallId)/goods"
            
            request.defaultInstance().GetRequest(url).responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    guard let JsonData = response.result.value else { return }
                    
                    let goods_list = JsonData["goods_list"] as? NSArray
                    
                    var goods_listArray = [HomeModel]()
                    
                    for  goods_list_dict in goods_list! {
                        
                        let homeSubject = HomeModel()
                        homeSubject.mapping(goods_list_dict as! Dictionary<String, AnyObject>)
                        goods_listArray.append(homeSubject)
                    }
                    self.delegate?.homeSubjectRequest(goods_listArray)
                    
                case .Failure(let error):
                    
                    print(error)
                }
            }
    }
    
}

protocol homeSubjectDataDelegate: NSObjectProtocol {
    
    func homeSubjectRequest(goods_listArray:NSArray)
    
}