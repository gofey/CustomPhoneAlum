//
//  GFLargePhotoController.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/15.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit

class GFLargePhotoController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    private var assetArray:Array<GFAsset> = Array<GFAsset>()
    
    private var isEnough = false
    
    private var selectedIndexArray:Array<Int> = Array<Int>() {
        didSet {
            //photoSelectedCount = selectedIndexArray.count
            numberLabel.text = "\(selectedIndexArray.count)"
            if selectedIndexArray.count <= 0 {
                numberLabel.isHidden = true
                submitBtn.isEnabled = false
            }else{
                numberLabel.isHidden = false
                submitBtn.isEnabled = true
                
                if selectedIndexArray.count == 9 && oldValue.count == 8 {
                    isEnough = true
                    collectionView.reloadData()
                }
                if selectedIndexArray.count == 8 && oldValue.count == 9 {
                    isEnough = false
                    collectionView.reloadData()
                }
            }
            
            
        }
    }
    
    private var collectionView:UICollectionView!
    
    private let cellReuseIdentifier = "GFPhotoNormalCellReuseIdentifier"
    
    private let numberLabel = UILabel.init(frame: CGRect.init(x: Screen.width - 45 - 33, y: (Global.BottomViewHeight - 30) / 2, width: 30, height: 30))
    
    
    let submitBtn = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.createUI()
    }
    
    private func createUI() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        let width = ItemSize.width
        flowLayout.itemSize = CGSize.init(width: width, height: width)
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 64, width: Screen.width, height: Screen.height - 64 - Global.BottomViewHeight), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GFPhotoNormalCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: Screen.height - Global.BottomViewHeight, width: Screen.width, height: Global.BottomViewHeight))
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.black
        
        bottomView.addSubview(numberLabel)
        numberLabel.backgroundColor = UIColor.green
        numberLabel.layer.cornerRadius = 15
        numberLabel.clipsToBounds = true
        numberLabel.font = UIFont.systemFont(ofSize: 18)
        numberLabel.textAlignment = .center
        numberLabel.isHidden = true
        numberLabel.textColor = UIColor.white
        
        submitBtn.frame = CGRect.init(x: numberLabel.frame.maxX + 3, y: 0, width: 40, height: Global.BottomViewHeight)
        bottomView.addSubview(submitBtn)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        submitBtn.isEnabled = false
        submitBtn.setTitleColor(UIColor.gray, for: .disabled)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(submitBtnClick))
        numberLabel.isUserInteractionEnabled = true
        numberLabel.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
