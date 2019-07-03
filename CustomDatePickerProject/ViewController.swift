//
//  ViewController.swift
//  CustomDatePickerProject
//
//  Created by lulin on 2019/6/24.
//  Copyright © 2019 lulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton.init()
        button.frame = CGRect.init(x: 50, y: 150, width: 200, height: 60)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("date", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
        
        let button1 = UIButton.init()
        button1.frame = CGRect.init(x: 50, y: 230, width: 200, height: 60)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button1.setTitleColor(.black, for: .normal)
        button1.setTitle("month", for: .normal)
        button1.backgroundColor = .blue
        button1.addTarget(self, action: #selector(buttonClicked1), for: .touchUpInside)
        view.addSubview(button1)
        
        let button2 = UIButton.init()
        button2.frame = CGRect.init(x: 50, y: 310, width: 200, height: 60)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button2.setTitleColor(.black, for: .normal)
        button2.backgroundColor = .blue
        button2.setTitle("week", for: .normal)
        button2.addTarget(self, action: #selector(buttonClicked2), for: .touchUpInside)
        view.addSubview(button2)
        
        let button3 = UIButton.init()
        button3.frame = CGRect.init(x: 50, y: 390, width: 200, height: 60)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button3.setTitleColor(.black, for: .normal)
        button3.backgroundColor = .blue
        button3.setTitle("custom", for: .normal)
        button3.addTarget(self, action: #selector(buttonClicked3), for: .touchUpInside)
        view.addSubview(button3)
    }

    @objc func buttonClicked(sender: UIButton) {
        
        let picker = BaseDatePickerView.init(dateStyle: .date, selectDateString: "2015-04-10")
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            print(contents)
        }
        picker.show()
    }
    @objc func buttonClicked1(sender: UIButton) {
     
        let picker = BaseDatePickerView.init(dateStyle: .month, selectDateString: "2012-6")
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            print(contents)
        }
        picker.show()
    }
    @objc func buttonClicked2(sender: UIButton) {
        
        let picker = BaseDatePickerView.init(dateStyle: .week(year: "2017", week: "09"), selectDateString: "")
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            print(contents)
        }
        picker.show()
    }
    @objc func buttonClicked3(sender: UIButton) {
        //最多为3列
        let picker = BaseDatePickerView.init(dateStyle: .custom, customList: [["测试1","测试2","测试3","测试3","测试5"],["测试1","测试2","测试3","测试3","测试5"],["测试1","测试2","测试3","测试3","测试5"]], selectRows: [3,0,0])
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            print(contents)
        }
        picker.show()
    }
}

