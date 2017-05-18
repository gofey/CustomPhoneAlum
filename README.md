# CustomPhoneAlum
调用系统相册有很多的局限性，有很多时候需要自定制相册，方便对照片的多选和其他操作

主要的功能当然是为了多张选择照片啦，

可以在代理方法中拿到你已经选择的照片

可以设置你一次选定的最多张数

但是单张照片显示的时候并不能放大缩小，功能以后完善，

第一版效果如下
![images](http://ooy23086i.bkt.clouddn.com/photoAlum2.jpeg)

![images](http://ooy23086i.bkt.clouddn.com/photoAlum3.jpeg)


要先加访问权限的设置，在允许访问相册的条件下才可以跳转
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
            gf.delegate = self
            let nav = UINavigationController.init(rootViewController: gf)

            self.present(nav, animated: true, completion: nil)
        }
哦哦！！！大家最关注的功能当然是在哪里获取已经选择的照片
如果你想拿到已经选择的照片，最直接的方法当然是代理，
引入GFPhotoAlubmDelegate
设置photoAlum.delegate = self;
代理方法
    func photoAlubmSelectedImageArray(selectedImgArray: Array<UIImage>) {
        print("\(selectedImgArray.count)")
        imageView.image = selectedImgArray[0]
    }

