//
//  ViewController.swift
//  CustomDatePickerProject
//
//  Created by lulin on 2019/6/24.
//  Copyright © 2019 lulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var selectContents = [String]()
    private var selectRows = [NSInteger]()
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
        
        let picker = BaseDatePickerView.init(pickerStyle: .date, selectDateString: sender.titleLabel!.text!)
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            self.selectContents = contents
            let title = contents.joined(separator: "-")
            sender.setTitle(title, for: .normal)
        }
        picker.show()
    }
    @objc func buttonClicked1(sender: UIButton) {
     
        let picker = BaseDatePickerView.init(pickerStyle: .month, selectDateString: sender.titleLabel!.text!)
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            self.selectContents = contents
            let title = contents.joined(separator: "-")
            sender.setTitle(title, for: .normal)
        }
        picker.show()
    }
    @objc func buttonClicked2(sender: UIButton) {
        if selectContents.count == 0 {
            selectContents = ["-1", "-1"]
        }
        let selectYear = selectContents[0]
        let selectWeek = selectContents[1]
        let picker = BaseDatePickerView.init(pickerStyle: .week(year: selectYear, week: selectWeek), selectDateString: "")
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            self.selectContents = contents
            let title = contents.joined(separator: "-")
            sender.setTitle(title, for: .normal)
        }
        picker.show()
    }
    @objc func buttonClicked3(sender: UIButton) {
        let customList = [["测试1","测试2","测试3","测试3","测试5"],
                          ["测试1","测试2","测试3","测试3","测试5"],
                          ["测试1","测试2","测试3","测试3","测试5"]]
        if selectRows.count == 0 {
            for _ in 0..<customList.count {
                selectRows.append(0)
            }
        }
        //最多为3列
        let picker = BaseDatePickerView.init(pickerStyle: .custom, customList: customList, selectRows: selectRows)
        picker.clickedConfirmHandler = { (contents: [String], selectedRows: [NSInteger]) in
            self.selectRows = selectedRows
            let title = contents.joined(separator: "-")
            sender.setTitle(title, for: .normal)
        }
        picker.show()
    }
}


