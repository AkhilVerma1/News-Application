//
//  DateFormatterUtility.swift
//  Apple News
//
//  Created by Akhil on 07/10/20.
//

import Foundation

class DateFormatterUtility{
    
    func dateFormatter(date : String) ->String {
            let dateFormat = DateFormatter()
            let todayDate = Date()
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateFormatted = dateFormat.date(from: date)
            if let _dateFormatted = dateFormatted {
                let difference = Calendar.current.dateComponents([.day], from: _dateFormatted, to: todayDate)
                return String(difference.day!)
            }
          return "0"
    }
}
