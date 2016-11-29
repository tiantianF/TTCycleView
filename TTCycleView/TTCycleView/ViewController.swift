//
//  ViewController.swift
//  TTCycleView
//
//  Created by tiantianfang on 2016/11/29.
//  Copyright © 2016年 fangtiantian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CycleViewDelegate{

    
    var cycleView : CycleView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    //MARK: methods
    
    func  setUpUI() {
        self.view.backgroundColor = UIColor.gray
        
        self.cycleView = CycleView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.width(), height: 200), imageArray: NSArray.init(array: ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg"]))
//        self.cycleView?.setImageArrays(imageArr: NSArray.init(array: ["1.jpg","2.jpg"]))
//        self.cycleView?.setIntervalTime(time: 1.0)
//        self.cycleView?.openAutoSroll(open: false)
        self.cycleView?.delegate = self
        self.view.addSubview(self.cycleView!)
        
    }
    
    func selectedAtIndex(index: Int) {
        NSLog("====selected:\(index)")
    }


}

