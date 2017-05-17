//
//  GFPhotoAllController.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/15.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit
import Photos
protocol GFPhotoAlubmDelegate: NSObjectProtocol {
    func photoAlubmSelectedImageArray(selectedImgArray: Array<UIImage>)
}

class GFPhotoAllController: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource {
    
    private var assetArray:Array<GFAsset> = Array<GFAsset>()

    private var isEnough = false
    
    weak var delegate:GFPhotoAlubmDelegate?
    
    private var selectedIndexArray:Array<Int> = Array<Int>() {
        didSet {
            //photoSelectedCount = selectedIndexArray.count
            numberLabel.text = "\(selectedIndexArray.count)"
            if selectedIndexArray.count == 0 {
                numberLabel.isHidden = true
                submitBtn.isEnabled = false
            }else{
                numberLabel.isHidden = false
                submitBtn.isEnabled = true

                if selectedIndexArray.count == Global.PhotoCountMax && oldValue.count == Global.PhotoCountMax - 1 {
                    isEnough = true
                    collectionView.reloadData()
                }
                if selectedIndexArray.count == Global.PhotoCountMax - 1 && oldValue.count == Global.PhotoCountMax {
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
        self.setNav()
        self.openAlubm()
        self.createUI()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let rightBtn = UIButton.init(type: .custom)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBtn.setTitle("取消", for: .normal)
        rightBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
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
        numberLabel.textColor = UIColor.white
        numberLabel.isHidden = true
        
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
    
    private func openAlubm() {
        /*
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count {
            let collection = smartAlbums[i]
            print("title:\(collection.localizedTitle ?? "nil")")
        }
        */
        let allPhotoOptions = PHFetchOptions.init()
        allPhotoOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: allPhotoOptions)
        for i in 0..<allPhotos.count {
            let asset = GFAsset.init(asset: allPhotos[i])
            self.assetArray.append(asset)
        }
    }
    //MARK: - collection Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GFPhotoNormalCell
        cell.asset = self.assetArray[indexPath.row]
        
        if isEnough && !(cell.asset?.isSelected)! {
            cell.alpha = 0.5
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        
        cell.selectBtnClick = {(asset) -> Void in
            self.assetArray[indexPath.row] = asset!
            if (asset?.isSelected)! {
                self.selectedIndexArray.append(indexPath.row)
            }else{
                self.selectedIndexArray.remove(at: self.selectedIndexArray.index(of: indexPath.row)!)
            }
            
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let largePhoto = GFLargePhotoController.init(assetArray: self.assetArray, selectedIndexArray: self.selectedIndexArray, currentIndex: indexPath.row, delegate: self.delegate) { (selectArray, assetArray) in
            self.assetArray = assetArray
            self.selectedIndexArray = selectArray
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(largePhoto, animated: true)
        
    }
    
    //MARK: - btn Action
    @objc private func submitBtnClick() {
        
        var imgArray = Array<UIImage>()
        let group = DispatchGroup()
        
        for index in self.selectedIndexArray {
            let selectedAsset = self.assetArray[index]
            
            group.enter()
            selectedAsset.loadfullResolutionImage(completion: { (image) in
                imgArray.append(image)
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            if let gate = self.delegate {
                
                print("\(imgArray.count)")
                gate.photoAlubmSelectedImageArray(selectedImgArray: imgArray)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc private func cancelClick() {
        self.dismiss(animated: true, completion: nil)
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
