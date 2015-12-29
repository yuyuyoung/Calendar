//
//  YYCalendarCell.swift
//  Calendar
//
//  Created by yangyu on 15/12/27.
//  Copyright © 2015年 YangYiYu. All rights reserved.
//

import UIKit

class YYCalendarCell: UICollectionViewCell {
    
    lazy var dateLabel: UILabel = {
        
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .Center
        self.addSubview(label)
        
        return label
    }()
    
}
