//
//  GFPhotoLargeCell.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/16.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit

class GFPhotoLargeCell: UICollectionViewCell {
    
    var asset:GFAsset? {
        didSet {
            asset?.loadfullResolutionImage(completion: { (image) in
                self.largePhotoImgView.image = image
            })
        }
    }
    
    private let largePhotoImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.black
        largePhotoImgView.frame = CGRect.init(x: 0, y: 0, width: Screen.width, height: frame.height)
        self.contentView.addSubview(largePhotoImgView)
        largePhotoImgView.clipsToBounds = true
        largePhotoImgView.contentMode = .scaleAspectFill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
