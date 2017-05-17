//
//  GFLargePhotoController.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/15.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit

class GFLargePhotoController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    weak var delegate:GFPhotoAlubmDelegate?
    
    private var assetArray:Array<GFAsset> = Array<GFAsset>()
    
    private var currentIndex:Int? {
        didSet {
            let asset = self.assetArray[currentIndex!]
            self.rightBtn.isSelected = asset.isSelected!
        }
    }
    
    
    private let rightBtn = UIButton.init(type: .custom)
    
    private var completion:((_ selectedArray: Array<Int> ,_ asseetArray: Array<GFAsset>) -> Void)?
    
    private var isEnough = false
    
    private let offSpaceX:CGFloat = 30.0
    
    private var selectedIndexArray:Array<Int> = Array<Int>() {
        didSet {
            numberLabel.text = "\(selectedIndexArray.count)"
            if selectedIndexArray.count <= 0 {
                numberLabel.isHidden = true
                submitBtn.isEnabled = false
            }else{
                numberLabel.isHidden = false
                submitBtn.isEnabled = true
                if selectedIndexArray.count == Global.PhotoCountMax && oldValue.count == Global.PhotoCountMax - 1 {
                    isEnough = true
                }
                if selectedIndexArray.count == Global.PhotoCountMax - 1 && oldValue.count == Global.PhotoCountMax {
                    isEnough = false
                }            
            }
            
        }
    }
    
    private lazy var alertController:UIAlertController = {
        let alertVC = UIAlertController.init(title: "你做多只能选\(Global.PhotoCountMax)张照片", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "我知道了", style: .cancel, handler: nil)
        
        alertVC.addAction(cancelAction)
        
        return alertVC
    }()
    
    private var collectionView:UICollectionView!
    
    private let cellReuseIdentifier = "GFPhotoLargeCellReuseIdentifier"
    
    private let numberLabel = UILabel.init(frame: CGRect.init(x: Screen.width - 45 - 33, y: (Global.BottomViewHeight - 30) / 2, width: 30, height: 30))
    
    
    private let submitBtn = UIButton.init(type: .custom)
    
    //MARK: - init方法
    convenience init(assetArray: Array<GFAsset>, selectedIndexArray: Array<Int>, currentIndex: Int, delegate: GFPhotoAlubmDelegate?, completion: @escaping (_ selectedArray: Array<Int> ,_ asseetArray: Array<GFAsset>) -> Void) {
        self.init()
        self.assetArray = assetArray
        self.selectedIndexArray = selectedIndexArray
        self.currentIndex =  currentIndex
        self.delegate = delegate
        self.completion = completion
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        self.setNav()
        self.createUI()
        
    }
    
    private func setNav() {
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBtn.setTitle("返回", for: .normal)
        leftBtn.addTarget(self, action: #selector(leftBtnBackClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBtn.setTitle("选中", for: .normal)
        rightBtn.setTitleColor(UIColor.red, for: .selected)
        rightBtn.addTarget(self, action: #selector(rightBtnBackClick(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
    }
    
    private func createUI() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: Screen.width + offSpaceX, height: Screen.height - 160)
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 80, width: Screen.width + offSpaceX, height: Screen.height - 160), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GFPhotoLargeCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = UIColor.black
        collectionView.contentOffset.x = CGFloat(self.currentIndex!) * (Screen.width + offSpaceX)
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
        numberLabel.text = "\(self.selectedIndexArray.count)"
        if selectedIndexArray.count == 0 {
            numberLabel.isHidden = true
            submitBtn.isEnabled = false
        }else{
            numberLabel.isHidden = false
            submitBtn.isEnabled = true
        }
        
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

    //MARK: - collection Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GFPhotoLargeCell
        cell.asset = self.assetArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: - scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentIndex = Int(scrollView.contentOffset.x / (Screen.width + offSpaceX))
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
    
    @objc private func leftBtnBackClick() {
        self.navigationController?.popViewController(animated: true)
        //执行闭包
        if let com = self.completion {
            com(self.selectedIndexArray,self.assetArray)
        }
    }
    
    @objc private func rightBtnBackClick(sender: UIButton) {
        if !sender.isSelected && isEnough {
            self.present(alertController, animated: true, completion: nil)
            return
        }
        sender.isSelected = !sender.isSelected
        let asset = self.assetArray[currentIndex!]
        asset.isSelected = sender.isSelected
        if asset.isSelected! {
            self.selectedIndexArray.append(currentIndex!)
        }else{
            self.selectedIndexArray.remove(at: self.selectedIndexArray.index(of: currentIndex!)!)
        }
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
