//
//  CycleCollectionViewCell.swift
//  
//
//  Created by tiantianfang on 2016/11/28.
//  Copyright © 2016年 fangtiantian. All rights reserved.
//

import UIKit

class CycleCollectionViewCell: UICollectionViewCell {
    
    var cellImage : UIImageView?

    override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
    
        self.cellImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        self.cellImage?.contentMode = .scaleToFill
        self.contentView.addSubview(self.cellImage!)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
