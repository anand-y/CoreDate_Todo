//
//  Date+Helper.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
