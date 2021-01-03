//
//  Earnings.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

struct Earnings: Codable {
    let symbol: String
    let actualEPS: Double
    let expectedEPS: Double
    let surprisePercentage: Double
    let reportDate: String
    let fiscalPeriod: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case actualEPS
        case expectedEPS = "consensusEPS"
        case surprisePercentage = "EPSSurpriseDollarPercent"
        case reportDate = "EPSReportDate"
        case fiscalPeriod
    }
}
