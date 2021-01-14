//
//  CryptocurrencyData.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/13/21.
//

import Foundation

struct CryptocurrencyData: Decodable {
    var ticker: String
    var price: String
    
    init(ticker: String, price: String) {
        self.ticker = ticker
        self.price = price
    }
    
    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case price = "lastestPrice"
    }
}
