//
//  AnalystRecommendation.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import Foundation

struct AnalystRecommendation: Decodable {
    let ratingBuy: Int
    let ratingOverweight: Int
    let ratingHold: Int
    let ratingUnderweight: Int
    let ratingSell: Int
    let ratingNone: Int
    let ratingScaleMark: Double // average of analyst recommendation scores
    
    enum CodingKeys: String, CodingKey {
        case ratingBuy = "ratingBuy"
        case ratingOverweight = "ratingOverweight"
        case ratingHold = "ratingHold"
        case ratingUnderweight = "ratingUnderweight"
        case ratingSell = "ratingSell"
        case ratingNone = "ratingNone"
        case ratingScaleMark = "ratingScaleMark"
    }
}
