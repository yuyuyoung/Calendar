//
//  YYCalendar.swift
//  Calendar
//
//  Created by yangyu on 15/12/27.
//  Copyright © 2015年 YangYiYu. All rights reserved.
//

import UIKit

class YYCalendar: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let weekDay = ["日", "壹", "贰", "叁", "肆", "伍", "陆"]
    
    var lastSelectedItem: Int = 0
    
    lazy var timeLabel: UILabel = {

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        return label
    }()
    
    lazy var rightSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: "toLastMonth")
        swipe.direction = .Right
        return swipe
    }()
    
    lazy var leftSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: "toNextMonth")
        swipe.direction = .Left
        return swipe
    }()

    
    lazy var collectionView: UICollectionView =  {
        
        let itemWidth = self.bounds.width / 7
        let itemHeight = (self.bounds.height - 44) / 7
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 44, width: self.bounds.width, height: self.bounds.height - 44), collectionViewLayout:layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(YYCalendarCell.classForCoder(), forCellWithReuseIdentifier:"Cell")
        
        return collection
    }()
    
    lazy var topLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        return label
    }()
    
    var date: NSDate {
        didSet {
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            let newDate = dateFormatter.stringFromDate(date)
            
            self.timeLabel.text = newDate
            
            UIView .transitionWithView(self, duration: 0.5, options: .TransitionCurlUp, animations: { () -> Void in

                }) { (complection) -> Void in
                   self.collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        
        date = NSDate(timeIntervalSinceNow: 3600 * 8)
        
        super.init(frame: frame)
        
        lastSelectedItem = self.day(date) + self.firstDayOfWeek(date) - 1

        self.addSubview(self.collectionView)
        self.addSubview(self.timeLabel)

        self.addGestureRecognizer(self.rightSwipe)
        self.addGestureRecognizer(self.leftSwipe)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func day(date: NSDate) -> Int {
        
        let day = NSCalendar.currentCalendar().component(.Day, fromDate: date)
        return day
    }
    
    func firstDayOfWeek(date: NSDate) -> Int {
        
        let calender = NSCalendar.currentCalendar()
        
        calender.firstWeekday = 1
        
        let component = calender.components([.Year, .Month, .Day], fromDate: date)
        component.day = 1
        
        var firstWeekDay: Int = 0
        
        if let firstDayOfMonthDate = calender.dateFromComponents(component) {
            firstWeekDay = calender.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: firstDayOfMonthDate)
        }
        
        return firstWeekDay - 1
    }
    
    func totalDaysOfMonth(date: NSDate) -> Int {
        let daysInMonth = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        return daysInMonth.length
    }
    
    func nextMonth(date: NSDate ) -> NSDate {
        
        let component = NSDateComponents()
        
        component.month = +1
        component.day = 0
        component.year = 0
        
        let nextDate = NSCalendar.currentCalendar().dateByAddingComponents(component, toDate: date, options: NSCalendarOptions.init(rawValue: 0))
        return nextDate!
    }
    
    func lastMonth(date: NSDate) -> NSDate {
        
        let component = NSDateComponents()
        component.month = -1
        component.day = 0
        component.year = 0
        let lastDate = NSCalendar.currentCalendar().dateByAddingComponents(component, toDate: date, options: NSCalendarOptions.init(rawValue: 0))
        return lastDate!
    }
    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return weekDay.count
        }
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! YYCalendarCell
        if indexPath.section == 0 {
            cell.dateLabel.text = "\(weekDay[indexPath.row])"
            cell.backgroundColor = UIColor(red: 21.0 / 255.0, green: 204.0 / 255.0, blue: 156.0 / 255.0, alpha: 1)
        }else {
            
            cell.backgroundColor = UIColor.whiteColor()
            let daysInMonth = self.totalDaysOfMonth(date)
            
            let firstDayInWeek = self.firstDayOfWeek(date)
            
            var dayNumber = 0
            let i = indexPath.row
            
            if (i < firstDayInWeek) || ( i > firstDayInWeek + daysInMonth - 1) {
                cell.dateLabel.text = ""
            }else {
                dayNumber = i - firstDayInWeek + 1
                
                cell.dateLabel.text = "\(dayNumber)"
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let lastIndex = NSIndexPath(forItem: lastSelectedItem, inSection: 1)
        if let lastCell = collectionView.cellForItemAtIndexPath(lastIndex) as? YYCalendarCell {
           lastCell.backgroundColor = UIColor.clearColor()
        }
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? YYCalendarCell {
            cell.backgroundColor = UIColor.redColor()
        }
        lastSelectedItem = indexPath.row
    }
    
    func toNextMonth() {
        self.date = self.nextMonth(date)
    }
    
    func toLastMonth() {
        self.date = self.lastMonth(date)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
