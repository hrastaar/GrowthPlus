//
//  SectorPerformance.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import Foundation
import SwiftUI

struct SectorPerformance: Decodable {
    let type: String
    let name: String
    let performance: Double
    let lastUpdated: Double

    var performanceString: String {
        String(format: "%.2f%%", performance * 100.00)
    }

    // Selects green / red depending on sector's performance
    var backgroundColor: Color {
        performance >= 0 ? Color.green : Color.red
    }

    var dateString: String {
        let d = NSDate(timeIntervalSince1970: lastUpdated)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyyy, h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        print(d.description)
        return formatter.string(from: d as Date)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case name
        case performance
        case lastUpdated
    }
}
