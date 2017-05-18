//
//  GFAsset.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/15.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit
import Photos

class GFAsset: NSObject {
    private var asset:PHAsset? {
        didSet {
            self.thumbnailImage = nil
        }
    }
    var isSelected:Bool?
    private var thumbnailImage:UIImage?
    private var fullResolutionImage:UIImage?
    
    convenience init(asset: PHAsset) {
        self.init()
        self.asset = asset
        self.isSelected = false
        /*DispatchQueue.global().async {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: ItemSize.width, height: ItemSize.height), contentMode: .aspectFill, options: nil, resultHandler: { (resultImg, info) in
                self.thumbnailImage = resultImg
            })
        }*/

    }
    
    public func loadThumbnailImage(completion: @escaping (UIImage) -> Void) {
        if let image = self.thumbnailImage {
            completion(image)
            return
        }
        DispatchQueue.global().async {
            
            PHImageManager.default().requestImage(for: (self.asset)!, targetSize: CGSize.init(width: ItemSize.width * 2, height: ItemSize.height  * 2), contentMode: .aspectFill, options: nil, resultHandler: { (resultImg, info) in
                DispatchQueue.main.async {
                    self.thumbnailImage = resultImg
                    if let image = resultImg {
                        completion(image)
                    }
                }
            })
        }
    }
    
    public func loadfullResolutionImage(completion: @escaping (UIImage) -> Void) {
        if let image = self.fullResolutionImage {
            completion(image)
            return
        }
        DispatchQueue.global().async {
            
            PHImageManager.default().requestImage(for: (self.asset)!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil, resultHandler: { (resultImg, info) in
                DispatchQueue.main.async {
                    self.fullResolutionImage = resultImg
                    if let image = resultImg {
                        completion(image)
                    }
                }
            })
        }
    }
}
