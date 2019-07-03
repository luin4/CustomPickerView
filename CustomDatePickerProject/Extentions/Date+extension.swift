//
//  Date.swift
//
//  Created by xxx on 2019/6/5.
//  Copyright ©  . All rights reserved.
//

import Foundation

extension Date {
    
    init(string: String, format: String) {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        let date = formatter.date(from: string) ?? Date()
        
        self = date
    }
    
    func string(_ dateFormat: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
    
    static func getWeekCountOfYear(_ year: NSInteger) -> NSInteger {
        var calendar = Calendar.current
        let endDay = "\(year)-12-31"
        let date = Date.init(string: endDay, format: "yyyy-MM-dd")
        calendar.firstWeekday = 2
        let compts = calendar.dateComponents([.yearForWeekOfYear,.weekOfYear, .year], from: date)
//        print("\(year)年最后一天所在年\(compts.yearForWeekOfYear!)的第\(compts.weekOfYear!)周")
        if let weekth = compts.weekOfYear, weekth == 1 {
            return 52
        }
        return compts.weekOfYear ?? 52
    }
    
    static func getWeekOrder() -> NSInteger {
        let date = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let comps = calendar.dateComponents([Calendar.Component.weekOfYear , Calendar.Component.weekday , Calendar.Component.weekdayOrdinal], from: date)
        
        return comps.weekOfYear ?? 0
    }
    
    var year: Int {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year], from: self)
        return comps.year ?? 0
    }
    
    var month: Int {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year,.month], from: self)
        return comps.month ?? 0
    }
    
    var day: Int {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year,.month, .day], from: self)
        return comps.day ?? 0
    }
    
 
}
