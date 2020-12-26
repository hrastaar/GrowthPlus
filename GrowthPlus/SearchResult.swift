//
//  SearchResult.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

// Data for each search result cell
struct SearchResult: Codable {
    let ticker: String
    let companyName: String
    let region: String
    
    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case companyName = "securityName"
        case region = "region"
    }
}
