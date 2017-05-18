//
//  AssetCell.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/5.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit
import Photos

class GFPhotoNormalCell: UICollectionViewCell {
    var selectBtnClick:((GFAsset?) -> Void)?
    var asset:GFAsset? {
        didSet {
            asset?.loadThumbnailImage(completion: { (thumImg) in
                self.imgView.image = thumImg
            })
            self.selectBtn.isSelected = (asset?.isSelected)!
        }
    }
    
    private let imgView = UIImageView.init()
    
    private let selectBtn = UIButton.init(type: UIButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化子控件
        imgView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.contentView.addSubview(imgView)
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        selectBtn.frame = CGRect.init(x: frame.width - 33, y: 3, width: 30, height: 30)
        selectBtn.setImage(#imageLiteral(resourceName: "CheckmarkNormal"), for: UIControlState.normal)
        selectBtn.setImage(#imageLiteral(resourceName: "CheckmarkSelected"), for: UIControlState.selected)
        selectBtn.addTarget(self, action: #selector(selectBtnClickAction(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(selectBtn)
    }

    @objc private func selectBtnClickAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.asset?.isSelected = sender.isSelected
        if self.selectBtnClick != nil{
            self.selectBtnClick!(self.asset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
