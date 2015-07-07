//
//  ViewController.swift
//  LSFlowView
//
//  Created by  tsou117 on 15/7/6.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,WaterFlayoutDelegate,LSImgZoomViewDelegate {

    var testImgArr = [Int]()
    var layout: MyLayout?
    var mycollectionview: UICollectionView?
    
    //相对位置
    var content_y =  CGFloat()
    
    override func viewWillAppear(animated: Bool) {
        getTestInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "瀑布流swift"
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        // Do any additional setup after loading the view, typically from a nib.
        
        //讨论按钮
        let rightItem = UIBarButtonItem(title: "讨论", style: UIBarButtonItemStyle.Plain, target: self, action: "actionOfDiscuss")
        self.navigationItem.rightBarButtonItem = rightItem
        
        //
        layout = MyLayout()
        layout!.delegate = self
        
        var cellNib:UINib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        
        //mycollectionview
        mycollectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout!)
        mycollectionview!.delegate = self
        mycollectionview!.dataSource = self
        mycollectionview!.backgroundColor = UIColor.clearColor()
        mycollectionview!.registerNib(cellNib, forCellWithReuseIdentifier: "MyCollectionViewCell")
        self.view.addSubview(mycollectionview!)
        
        //play
        print(NSInteger.max)
    }

    //设置测试数据
    func getTestInfo(){
        
        //
        //在取随机14张图片 1~18 包括1 不包括18
        testImgArr = createGenerator(14)(1,18)

        print(testImgArr)

        
    }
    
    //返回一个随机不重复数组
    func createGenerator(count:Int)->(Int,Int)->[Int]{
        
        //http://stackoverflow.com/questions/24270693/nested-recursive-function-in-swift
        var generator:(Int,Int)->[Int] = {_,_ in return []} // give it a no-op definition
        var total = count
        generator = {min,max in
            if (total <= 0 || min>max) {
                return []
            }else{
                total--;
                var random = Int(arc4random_uniform(UInt32(max-min)))
                var mid = min + random
                return [mid]+generator(min, mid-1)+generator(mid+1, max)
            }
        }
        
        return generator
    }
    
    //讨论
    func actionOfDiscuss(){
        var web_vc = DiscussViewController()
        web_vc.url = "http://www.cocoachina.com/bbs/read.php?tid=309669&page=1&toread=1#tpc"
        self.navigationController!.pushViewController(web_vc, animated: true)
    }

    //WaterFlayoutDelegate
    func collectionView(collectionview: UICollectionView, layout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize {
        //
        let item_w = (collectionview.frame.size.width-24)*0.5
        
        //对应图片下标
        let imgIndex = testImgArr[indexPath.row]
        
        //取出当前图片
        let item_img = UIImage(named: NSString(format: "test_%d.png",imgIndex))
        
        let imgsize = item_img!.size
        let img_h =  (imgsize.height*item_w)/imgsize.width
        
        return CGSizeMake(item_w, img_h)
    }
    
    //UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return testImgArr.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCollectionViewCell", forIndexPath: indexPath) as MyCollectionViewCell
        
        //对应图片下标
        let imgIndex = testImgArr[indexPath.row]
        
        //取出当前图片
        let item_img = UIImage(named: NSString(format: "test_%d.png",imgIndex))
        
        cell.imageview.image = item_img
        
        return cell
    }
    
    
    
    //UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as MyCollectionViewCell
        cell.imageview.hidden = true
        
        var baseframe = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-content_y, cell.frame.size.width, cell.frame.size.height)
        
        var zoomv = LSImgZoomView(baseframe: baseframe)
        zoomv.delegate = self
        zoomv.setCurrImg(cell.imageview.image!)
        zoomv.show()
        
        zoomv.blockClose = {(done:Bool) -> Void in
            //
            cell.imageview.hidden = false
        }
    }

    //LSImgZoomViewDelegate
    func lsImgZoomView(close: Bool) {
        //
        if (close){
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //
        content_y = scrollView.contentOffset.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

