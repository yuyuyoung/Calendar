//
//  ViewController.swift
//  Calendar
//
//  Created by yangyu on 15/12/25.
//  Copyright © 2015年 YangYiYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.view.addSubview(YYCalendar(frame: CGRectMake(0, 20, self.view.bounds.width, 352)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

