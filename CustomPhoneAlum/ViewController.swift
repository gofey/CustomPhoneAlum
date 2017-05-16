//
//  ViewController.swift
//  CustomPhoneAlum
//
//  Created by 厉国辉 on 2017/5/5.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton.init(type: UIButtonType.system)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(presentPhotoAlubm), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.black
        btn.frame = CGRect.init(x: 100, y: 100, width: 75, height: 30)
        btn.setTitle("打开相册", for: .normal)
    }

    func presentPhotoAlubm() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            // 用户拒绝,提示开启
            print("denied")
        case .notDetermined:
            // 尚未请求,立即请求
            print("notDetermined")
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status == .authorized {
                    // 用户同意
                    
                    let gf = GFPhotoAllController()
                    
                    let nav = UINavigationController.init(rootViewController: gf)

                    self.present(nav, animated: true, completion: nil)
                }
            })
        case .restricted:
            // 用户无法解决的无法访问
            print("restricted")
        case .authorized:
            // 用户已授权
            print("authorized")
            
            let gf = GFPhotoAllController()
            
            let nav = UINavigationController.init(rootViewController: gf)

            self.present(nav, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

