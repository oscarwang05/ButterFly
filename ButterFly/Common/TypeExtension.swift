//
//  TypeExtension.swift
//  ButterFly
//
//  Created by Yan Wang on 14/06/2022.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter.date(from: self)!
    }
}
