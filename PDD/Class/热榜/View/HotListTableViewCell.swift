//
//  HotListTableViewCell.swift
//  PDD
//
//  Created by 周磊 on 16/3/18.
//  Copyright © 2016年 ZL. All rights reserved.
//

import UIKit

class HotListTableViewCell: UITableViewCell {
    /// 序号
    var numericalOrder:UILabel?
    /**图片*/
    var goodsImageView:UIImageView?
     /**商品名称*/
    var  goodsName:UILabel?
      /**售出数量*/
    var goodsSalesAmount:UILabel?
    ///开团背景图片
    var regimentImage:UIImageView?
    ///开团人数
    var regimentPersonLabel:UILabel?
    ///开团价
    var piceLabel:UILabel?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        numericalOrder = UILabel()
        numericalOrder?.textColor = UIColor.grayColor()
        numericalOrder?.font = UIFont.systemFontOfSize(20)
        numericalOrder?.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(numericalOrder!)
        numericalOrder?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp_centerY).offset(0)
            make.height.equalTo(20)
        })
        goodsImageView = UIImageView()
        self.contentView.addSubview(goodsImageView!)
        goodsImageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(numericalOrder!.snp_right).offset(10)
            make.centerY.equalTo(self.snp_centerY).offset(0)
            make.width.height.equalTo(100)
        })
        goodsName = UILabel()
        goodsName?.font = UIFont.systemFontOfSize(16)
        goodsName?.numberOfLines = 3
        goodsName?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.contentView.addSubview(goodsName!)
        goodsName?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(goodsImageView!.snp_right).offset(10)
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        })
        goodsSalesAmount = UILabel()
        self.contentView.addSubview(goodsSalesAmount!)
        goodsSalesAmount?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(goodsImageView!.snp_right).offset(10)
            make.bottom.equalTo(self).offset(-50)
        })
        
        regimentImage = UIImageView()
        regimentImage?.image = UIImage(named: "rekaituan")
        regimentImage!.layer.masksToBounds = true
        regimentImage!.layer.cornerRadius = 5
        self.contentView.addSubview(regimentImage!)
        regimentImage?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(goodsSalesAmount!.snp_bottom).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(goodsImageView!.snp_right).offset(10)
            make.width.equalTo(ScreenWidth-165)

        })
        regimentPersonLabel = UILabel()
        regimentPersonLabel?.font = UIFont.systemFontOfSize(10)
        regimentPersonLabel?.textColor = UIColor.grayColor()
         self.contentView.addSubview(regimentPersonLabel!)
        regimentPersonLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.centerY.equalTo(regimentImage!.snp_centerY).offset(0)
            make.left.equalTo(regimentImage!.snp_left).offset(5)
        })
        
        piceLabel = UILabel()
        piceLabel?.font = UIFont.systemFontOfSize(15)
        piceLabel?.textColor = UIColor.redColor()
         self.contentView.addSubview(piceLabel!)
        piceLabel?.snp_makeConstraints(closure: { (make) -> Void in
            make.centerY.equalTo(regimentImage!.snp_centerY).offset(0)
            make.left.equalTo(regimentPersonLabel!.snp_right).offset(20)
        })
        
        if ScreenWidth < 375 {
            piceLabel?.snp_updateConstraints(closure: { (make) in
                make.centerY.equalTo(regimentImage!.snp_centerY).offset(0)
                make.left.equalTo(regimentPersonLabel!.snp_right).offset(5)
            })
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseData(hotList:HotListModel,index:String) {
        
        if hotList.customer_num != nil {
            regimentPersonLabel?.text = hotList.customer_num! + "人团"
        }
        if hotList.price != nil {
            var pice :Float?
            pice = NSString(string: hotList.price!).floatValue / 100
            var price:String?
            price = String(format: "%.2f", pice!)
            piceLabel?.text = "¥" +  price!
        }
        
        
        numericalOrder?.text = index
        let imageURL = NSURL(string:hotList.thumb_url!)
        goodsImageView?.pdd_setImageWithURL(imageURL!, placeholderImage: UIImage(named: "wu.jpg")!)
        goodsName?.text = hotList.goods_name

        if hotList.cnt != nil && hotList.time == nil {
            
            let salesAmount = "已售 " + hotList.cnt! + " 件"
            
            goodsSalesAmount?.attributedText =  setupAttributeString(salesAmount, highlightText: "件")

            
        }else if hotList.cnt == nil && hotList.time != nil {
            
 /// 获取服务器返回的时间戳并转换成时间
            let timeStamp = hotList.time
            let dateTime =  timeStamp!.timeStampToInteger(timeStamp!)
 /// 获取当前时间
            let newDate = NSDate()
//            let timeFormatter = NSDateFormatter()
//            timeFormatter.dateFormat = "yyyy年MM月dd日 HH时mm分ss秒"
//            let nowTime = timeFormatter.stringFromDate(newDate) as String
            
 /// 两个日期之间相隔多少秒
            let  secondsInterval: Double = newDate.timeIntervalSinceDate(dateTime)
 /// 计算相差几分钟
            /// lroundf是一个全局函数，作用是将浮点数四舍五入转为整数。
            let minutes = lroundf(Float(secondsInterval/60))
            
            goodsSalesAmount?.font = UIFont.systemFontOfSize(13)
            goodsSalesAmount?.textColor = UIColor.grayColor()
            
            if minutes < 60 {
                goodsSalesAmount?.text = "\(minutes)分钟前"
            }else  {
                let hour = lroundf(Float(minutes/60))
                goodsSalesAmount?.text = "\(hour)小时前"
            }
            
        }else {
            
            goodsSalesAmount?.hidden = true
        }
    }
   
    
    func setupAttributeString(text : NSString, highlightText : NSString) -> NSMutableAttributedString {
        
        let hightlightTextRange = text.rangeOfString(highlightText as String)
        
        let attributeStr = NSMutableAttributedString.init(string: text as String)
        
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: hightlightTextRange)
        attributeStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(13),range: hightlightTextRange)
        
        attributeStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(13),range: NSMakeRange(0,2))
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(),
            range: NSMakeRange(0, 2))
        
        return attributeStr
    }
}
