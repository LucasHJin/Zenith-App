//
//  DataPoint.swift
//  ZenithApp
//
//  Created by Lucas Jin on 2024-02-19.
//

import Foundation


struct DataPoint: Identifiable {
    var id = UUID().uuidString
    var date: String
    var RM: Double
}
