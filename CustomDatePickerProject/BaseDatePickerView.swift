//
//  BaseDatePickerView.swift
//
//  Created by lulin on 2019/6/5.
//  Copyright © . All rights reserved.
//

import UIKit

let ScreenHeight: CGFloat = UIScreen.main.bounds.height
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let Width_Scale: CGFloat = ScreenWidth/320


private var startYear = 1960
private let cancelButnTag: NSInteger    = 101
private let confirmButnTag: NSInteger   = 102


enum PickerStyle {
    case unKnow
    case date    //年月日
    case month   //年月
    case week(year: String, week: String)    //年周
    case custom   //年月
}

class BaseDatePickerView: UIView {
    var clickedConfirmHandler: ((_ backContents : [String], _ selectedRows: [NSInteger]) -> Void)?
    
    private var bottomView = UIView()   //底部白色背景图
    private lazy var titleLabel: UILabel = {     //标题
        let title = UILabel()
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: CGFloat(15))
        return title
    }()
    private lazy var cancelButton: UIButton = {      //取消按钮
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15))
        cancelButton.tag = cancelButnTag
        cancelButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return cancelButton
    }()
    private lazy var confirmButton: UIButton = {     //确认按钮
        let confirmButton = UIButton()
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.gray, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15))
        confirmButton.tag = confirmButnTag
        confirmButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return confirmButton
    }()
    private lazy var lineView = UIView()  //分割线
    private lazy var pickerView = UIPickerView()  //picker
    
    //MARK: 数据相关
    var pickerStyle: PickerStyle = .date
    
    private var components = NSInteger() //列
    private var rowsInComponent = [NSInteger]() //每列的Range集合
    private var selectedRows = [NSInteger]() //选中行集合
    
    private var firstSelectedRow = 0
    private var secondSelectedRow = 0
    private var thirdSelectedRow = 0
    
    private var customList = [[String]]() //自定义数组
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //日期类型
    convenience init(dateStyle: PickerStyle, selectDateString: String) {
        self.init(frame: CGRect.zero)
        self.pickerStyle = dateStyle
        
        self.setUpSubViews()
        
        switch dateStyle {
        case .date:
            reloadDatePickerData(selectDateString: selectDateString)
        case .month:
            reloadMonthPickerData(selectDateString: selectDateString)
        case .week(let year, let week):
            let selectYear = NSInteger(year) ?? 0
            let selectWeek = NSInteger(week) ?? 0
            reloadWeakPickerData(selectYear: selectYear, selectWeek: selectWeek)
        default:
            break
        }
    }
    //自定义类型(最多支持3列,可扩展更多列(加参数))
    convenience init(dateStyle: PickerStyle, customList: [[String]], selectRows: [NSInteger]) {
        self.init(frame: CGRect.zero)
        self.pickerStyle = dateStyle
        
        self.setUpSubViews()
        
        self.components = (customList.count<3) ?  customList.count : 3
        self.customList = customList
        
        for i in 0...self.components-1 {
            let rows = customList[i]
            self.rowsInComponent.append(rows.count)
        }
        
        self.selectedRows = selectRows
        setPickerViewSelectedRow()
        
    }
    //MARK: 添加子控件
    private func setUpSubViews() {
        
        self.backgroundColor = UIColor.init(white: 0.2, alpha: 0.2)
        
        self.addSubview(bottomView)
        bottomView.addSubview(cancelButton)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(confirmButton)
        bottomView.addSubview(lineView)
        bottomView.addSubview(pickerView)
        addTapGestureTo(view: self)
        
        addSubviewsMake()
    }
    
    private func addSubviewsMake() {
        
        bottomView.backgroundColor = UIColor.red
        lineView.backgroundColor = UIColor.blue
        pickerView.backgroundColor = UIColor.white
        
        pickerView.dataSource = self
        pickerView.delegate = self
        bottomView.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 250*Width_Scale)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(15)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top)
            make.leading.equalTo(bottomView.snp.leading)
            make.size.equalTo(CGSize(width: 90, height: 45))
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top)
            make.trailing.equalTo(bottomView.snp.trailing)
            make.height.equalTo(45)
            make.width.equalTo(90)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(1)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalTo(bottomView)
        }
        
    }
    
    private func addTapGestureTo(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGesture(_ sender: UIGestureRecognizer) {
        self.dismiss()
    }
    
    @objc private func buttonClicked(button: UIButton) {
        
        switch button.tag {
        case confirmButnTag:
            var backContents = [String]()
            
            switch pickerStyle {
            case .date:
                if selectedRows.count > 0{
                    let content = selectedRows[0]+startYear
                    backContents.append("\(content)")
                }
                if selectedRows.count > 1{
                    let content = selectedRows[1]+1
                    backContents.append("\(content)")
                }
                if selectedRows.count > 2{
                    let content = selectedRows[2]+1
                    backContents.append("\(content)")
                }
            case .month:
                if selectedRows.count > 0{
                    let content = selectedRows[0]+startYear
                    backContents.append("\(content)")
                }
                if selectedRows.count > 1{
                    let content = selectedRows[1]+1
                    backContents.append("\(content)")
                }
            case .week:
                if selectedRows.count > 0{
                    let content = selectedRows[0]+startYear
                    backContents.append("\(content)")
                }
                if selectedRows.count > 1{
                    let content = selectedRows[1]+1
                    backContents.append("\(content)")
                }
                
            case .custom:
                if selectedRows.count > 0{
                    let rowList = customList[0]
                    let selectRow = selectedRows[0]
                    backContents.append(rowList[selectRow])
                }
                if selectedRows.count > 1{
                    let rowList = customList[1]
                    let selectRow = selectedRows[1]
                    backContents.append(rowList[selectRow])
                }
                if selectedRows.count > 2{
                    let rowList = customList[2]
                    let selectRow = selectedRows[2]
                    backContents.append(rowList[selectRow])
                }
            case .unKnow: break
            }
            if clickedConfirmHandler != nil {
                clickedConfirmHandler!(backContents, selectedRows)
            }
            self.dismiss()
        case cancelButnTag:
            self.dismiss()
        default:
            break
        }
        self.dismiss()
    }
    
}
//MARK: 展示和收藏
extension BaseDatePickerView {
    func show() {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            
            UIView.animate(withDuration: 0.2) {
                self.bottomView.y = ScreenHeight-self.bottomView.height
            }

            self.snp.makeConstraints({ (make) in
                make.edges.equalTo(window!)
            })
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomView.y = ScreenHeight
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
}
//MARK:初始化数据
extension BaseDatePickerView {
    //MARK: 年月日
    private func reloadDatePickerData(selectDateString: String) {
        startYear = 1960
        
        let calendar = Calendar.init(identifier: .gregorian) //公历
        var comps = DateComponents()   //一个封装日期的类
        
        let result = getCalendarComponent()
        comps = calendar.dateComponents(result.calendarSet, from: Date())
        
        if selectDateString.isEmpty {
            firstSelectedRow = comps.year!
            secondSelectedRow = comps.month!
            thirdSelectedRow = comps.day!
        }else{
            let selectDate = Date.init(string: selectDateString, format: result.dateFormatter)
            firstSelectedRow = selectDate.year
            secondSelectedRow = selectDate.month
            thirdSelectedRow = selectDate.day
        }
        
        let yearRange = comps.year! - startYear + 1
        let monthRange = getMonths(selectedYear: firstSelectedRow)
        let dayRange = getDays(year: firstSelectedRow, month: secondSelectedRow)
        //每列range集合
        rowsInComponent = [yearRange, monthRange, dayRange]
        //记录select位置
        selectedRows = [firstSelectedRow-startYear>0 ? firstSelectedRow-startYear:0, secondSelectedRow-1, thirdSelectedRow-1]
        setPickerViewSelectedRow()
    }
    private func reloadMonthPickerData(selectDateString: String) {
        startYear = 1960
        
        let calendar = Calendar.init(identifier: .gregorian) //公历
        var comps = DateComponents()   //一个封装日期的类
        
        let result = getCalendarComponent()
        comps = calendar.dateComponents(result.calendarSet, from: Date())
        
        if selectDateString.isEmpty {
            firstSelectedRow = comps.year!
            secondSelectedRow = comps.month!
        }else{
            let selectDate = Date.init(string: selectDateString, format: result.dateFormatter)
            firstSelectedRow = selectDate.year
            secondSelectedRow = selectDate.month
        }
        
        let yearRange = comps.year! - startYear + 1
        let monthRange = getMonths(selectedYear: firstSelectedRow)
        //每列range集合
        rowsInComponent = [yearRange, monthRange]
        //记录select位置
        selectedRows = [firstSelectedRow-startYear>0 ? firstSelectedRow-startYear:0, secondSelectedRow-1]
        setPickerViewSelectedRow()
    }
    //MARK: week
    private func reloadWeakPickerData(selectYear: NSInteger, selectWeek: NSInteger) {
        startYear = 2019
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let result = getCalendarComponent()
        
        var comps = DateComponents()
        comps = calendar.dateComponents(result.calendarSet, from: Date())
        if selectYear==0 && selectWeek==0 {
            firstSelectedRow = comps.year!
            secondSelectedRow = comps.weekOfYear!
        }else{
            firstSelectedRow = selectYear
            secondSelectedRow = selectWeek
        }
        selectedRows = [firstSelectedRow-startYear, secondSelectedRow-1]
        //年r
        let yearRange = comps.year! - startYear + 1
        //周
        let weekRange = getWeeks(selectedYear: firstSelectedRow)
        rowsInComponent = [yearRange, weekRange]
       
        setPickerViewSelectedRow()
    }
    
}

//MARK: UIPickerViewDataSource, UIPickerViewDelegate
extension BaseDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowsInComponent[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let width = ScreenWidth/CGFloat(rowsInComponent.count)
        
        let label  = UILabel(frame: CGRect(x: ScreenWidth * CGFloat(component)/6 , y: 0, width: width, height: 30))
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        
        switch pickerStyle {
        case .date:
            switch component {
            case 0:
                label.text = "\(startYear + row)年"
            case 1:
                label.text="\(row + 1)月"
            case 2:
                label.text="\(row + 1)日"
            default:
                break
            }
        case .month:
            switch component {
            case 0:
                label.text = "\(startYear + row)年"
            case 1:
                label.text="\(row + 1)月"
            default:
                break
            }
        case .week:
            switch component {
            case 0:
                label.text = "\(startYear + row)年"
            case 1:
                label.text="第\(row + 1)周"
            default:
                break
            }
        case .custom:
            let rows = customList[component]
            label.text = rows[row]
        default:
            break
        }
        
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerStyle {
        case .date:
            switch component {
            case 0:
                firstSelectedRow = startYear+row
                let monthRange = getMonths(selectedYear: firstSelectedRow)
                if secondSelectedRow > monthRange {
                    secondSelectedRow = monthRange
                }
                let dayRange = getDays(year: firstSelectedRow, month: secondSelectedRow)
                if thirdSelectedRow > dayRange {
                    thirdSelectedRow = dayRange
                }
                rowsInComponent[1...2] = [monthRange, dayRange]
                selectedRows = [firstSelectedRow-startYear, secondSelectedRow-1, thirdSelectedRow-1]
                setPickerViewSelectedRow()
            case 1:
                secondSelectedRow = row+1
                let dayRange = getDays(year: firstSelectedRow, month: secondSelectedRow)
                if thirdSelectedRow > dayRange {
                    thirdSelectedRow = dayRange
                }
                rowsInComponent[2] = dayRange
                selectedRows[1...2] = [secondSelectedRow-1, thirdSelectedRow-1]
                setPickerViewSelectedRow()
            case 2:
                thirdSelectedRow = row+1
                selectedRows[2] = thirdSelectedRow
            default:
                break
            }
        case .month:
            switch component {
            case 0:
                firstSelectedRow = startYear+row
                let monthRange = getMonths(selectedYear: firstSelectedRow)
                if secondSelectedRow > monthRange {
                    secondSelectedRow = monthRange
                }
                rowsInComponent[1] = monthRange
                selectedRows = [firstSelectedRow-startYear, secondSelectedRow-1]
                setPickerViewSelectedRow()
            case 1:
                secondSelectedRow = row+1
                selectedRows[1] = secondSelectedRow
            default:
                break
            }
        case .week:
            switch component {
            case 0:
                firstSelectedRow = startYear+row
                let weekRange = getWeeks(selectedYear: firstSelectedRow)
                if secondSelectedRow > weekRange {
                    secondSelectedRow = weekRange
                }
                rowsInComponent[1] = weekRange
                selectedRows = [firstSelectedRow-startYear, secondSelectedRow-1]
                setPickerViewSelectedRow()
            case 1:
                secondSelectedRow = row+1
                selectedRows[1] = secondSelectedRow-1
            default:
                break
            }
        case .custom:
            
            selectedRows[component] = row
        default:
            break
        }
    }
    
}

extension BaseDatePickerView {
    //获取Calendar格式,date格式
    private func getCalendarComponent() -> (calendarSet: Set<Calendar.Component>, dateFormatter: String) {
        var calendarComponent: Set<Calendar.Component>!
        var dateFormatter: String!
        switch pickerStyle {
        case .date:
            calendarComponent = [.year,.month,.day]
            dateFormatter = "yyyy-MM-dd"
            components = 3
        case .month:
            calendarComponent = [.year,.month]
            dateFormatter = "yyyy-MM"
            components = 2
        case .week:
            calendarComponent = [.year,.weekOfYear]
            dateFormatter = "yyyy-w"
            components = 2
        default:
            break
        }
        return (calendarSet: calendarComponent, dateFormatter: dateFormatter)
        
    }
    //设置选中row
    private func setPickerViewSelectedRow() {
        if selectedRows.count>0 {
            self.pickerView.selectRow(selectedRows[0], inComponent: 0, animated: false)
        }
        if selectedRows.count>1 {
            self.pickerView.selectRow(selectedRows[1], inComponent: 1, animated: false)
        }
        if selectedRows.count>2 {
            self.pickerView.selectRow(selectedRows[2], inComponent: 2, animated: false)
        }
        self.pickerView.reloadAllComponents()
    }
    //计算选中年有多少月
    private func getMonths(selectedYear: NSInteger) -> NSInteger {
        guard Date().year == selectedYear else {
            return 12
        }
        return Date().month
    }
    //计算选中月有多少天
    private func getDays(year: NSInteger, month: NSInteger) -> NSInteger {
        var day: Int = 0
        guard Date().year == year &&
            Date().month == month else {
                switch(month){
                case 1,3,5,7,8,10,12:
                    day = 31
                case 4,6,9,11:
                    day = 30
                case 2:
                    if (year%4==0) {
                        day=29
                    }else{
                        day=28
                    }
                default: break
                }
                return day
        }
        day = Date().day
        
        return day;
    }
    //计算选中年有多少周
    func getWeeks(selectedYear: NSInteger) -> NSInteger {
        guard Date().year == selectedYear else {
            return Date.getWeekCountOfYear(selectedYear)
        }
        
        return Date.getWeekOrder()
    }
}
