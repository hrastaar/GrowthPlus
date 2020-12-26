//
//  StockNewsArticle.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

// Info stored for news section of stock view page
struct StockNewsArticle: Codable {
    let language: String
    let date: Int
    let headline: String
    let source: String
    let articleURL: String
    let related: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case date = "datetime"
        case headline = "headline"
        case source = "source"
        case articleURL = "url"
        case related = "related"
        case imageURL = "image"
    }
}
