//
//  CycleView.swift
//  
//
//  Created by tiantianfang on 2016/11/28.
//  Copyright © 2016年 fangtiantian. All rights reserved.
//

import UIKit

@objc protocol CycleViewDelegate {
    func selectedAtIndex(index : Int)
}

class CycleView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    //MARK:public property
    
    //分页控制器的默认颜色
    var pageControlDefaultColor : UIColor = UIColor.white{
        didSet{
            self.pageControl?.pageIndicatorTintColor = pageControlDefaultColor
        }
    }
    //分页控制器的选中默认颜色
    var pageControlSelectDefaultColor : UIColor = UIColor.black{
        didSet{
            self.pageControl?.currentPageIndicatorTintColor = pageControlSelectDefaultColor
        }
    }
    
    //轮播时间，默认两秒
    var intervalTime : CGFloat = 2.0
    
    //是否开启自动滚动   默认开启
    var isOpenAutoScroll : Bool = true
    
    var delegate : CycleViewDelegate? = nil
    
    //MARK:private Property
    
    //定时器
    private var timer : Timer?
    
    //分页
    private var pageControl : UIPageControl?
    
    //图片数组
    private var imageArray = NSArray.init()
    
    //滚动视图
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: self.width(), height: self.height())
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        var temp : UICollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        temp.backgroundColor = UIColor.white
        temp.showsHorizontalScrollIndicator = false
        temp.isPagingEnabled = true
        return temp
    }()
    
    //MARK:Methods
    init(frame: CGRect,imageArray: NSArray) {
        
        super.init(frame: frame)
        self.initViews(imageArr: imageArray);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化视图
    func initViews(imageArr: NSArray){
        
        //self
        self.backgroundColor = UIColor.white
        
        self.imageArray = imageArr
        
        //collection
        self.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CycleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.reloadData()
        
        //pageControl
        self.pageControl = UIPageControl.init(frame: CGRect.init(x: self.right()-self.width()/4.0, y: self.height()-30  , width: self.width()/4.0, height: 30))
        self.pageControl!.numberOfPages = imageArr.count
        self.pageControl!.currentPage = 0
        self.pageControl!.pageIndicatorTintColor = UIColor.white
        self.pageControl!.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(self.pageControl!)
        
        self.setImageArrays(imageArr: imageArr)
    }
    
    //设置图片数组
    func setImageArrays(imageArr : NSArray){
        
        self.pageControl!.numberOfPages = imageArr.count
        
        if imageArr.count > 1{
            let tempArr = NSMutableArray(array: imageArr)
            tempArr.add(tempArr.firstObject!)
            tempArr.insert(tempArr.lastObject!, at:0)
            self.imageArray = tempArr
            
            //timer
            self.timer = Timer.init(timeInterval: TimeInterval(self.intervalTime), target: self, selector: #selector(self.nextPage), userInfo: nil, repeats: true)
          
            RunLoop.current.add(self.timer!, forMode: .commonModes)
            

            self.collectionView.reloadData()
            //停在第一张
            self.collectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .left, animated: false)
        }else{
            self.imageArray = imageArr
            self.collectionView.reloadData()
        }
        
    }
    
    //设置轮播时间间隔
    func setIntervalTime(time : CGFloat){
        self.intervalTime = time
        self.removeTimer()
        self.addTimer()
    }
    
    //设置是否开启轮播
    func openAutoSroll(open : Bool){
        self.isOpenAutoScroll = open
        self.removeTimer()
        self.addTimer()
    }
    
    //添加定时器
    func addTimer(){
        if self.isOpenAutoScroll && self.timer == nil{
            self.timer = Timer.init(timeInterval: TimeInterval(self.intervalTime), target: self, selector: #selector(self.nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .commonModes)
        }
    }
    
    
    //销毁定时器
    func removeTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }

    //自动翻页
    func nextPage(){
        
        var item = Int(self.collectionView.contentOffset.x) / Int(self.width()) % self.imageArray.count
        item += 1

        if self.isOpenAutoScroll{
            self.collectionView.scrollToItem(at: IndexPath.init(row: item, section: 0), at: .centeredHorizontally, animated: true)
        }
      

    }
    
    //MARK:CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CycleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CycleCollectionViewCell
        

        let imageNamed : String = self.imageArray[indexPath.row] as! String
        let cellImage = UIImage.init(named: imageNamed)
        cell.cellImage!.image = cellImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil{
            self.delegate!.selectedAtIndex(index: indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNum = Int(scrollView.contentOffset.x) / Int(self.collectionView.width()) % self.imageArray.count
        
        //调整位置
        if pageNum == 0{
            self.collectionView.scrollToItem(at: IndexPath.init(row: (self.imageArray.count-2), section: 0), at: .left, animated: false)
        }
        
        if pageNum == (self.imageArray.count-1){
            self.collectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .left, animated: false)
        }
        
        //计算页数
        self.pageControl?.currentPage = pageNum-1
        if pageNum == 0{
            self.pageControl!.currentPage = self.imageArray.count - 2
        }
        if pageNum == self.imageArray.count-1{
            self.pageControl!.currentPage = 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    
}
