//
//  CompanyProfile.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/26/20.
//

import Foundation

class CompanyProfile: ObservableObject, Codable {
    var ticker: String
    var companyName: String
    var numEmployees: Int
    var exchange: String
    var industry: String
    var website: String
    var description: String
    var CEO: String
    var tags: [String]
    // Address / Contact Info
    var address: String
    var state: String
    var city: String
    var zip: String
    var country: String
    var phone: String
    var isValidProfile: Bool {
        !ticker.isEmpty
    }
    
    init() {
        self.ticker = ""
        self.companyName = ""
        self.numEmployees = 0
        self.exchange = ""
        self.industry = ""
        self.website = ""
        self.description = ""
        self.CEO = ""
        self.tags = [String]()
        self.address = ""
        self.state = ""
        self.city = ""
        self.zip = ""
        self.country = ""
        self.phone = ""
    }
    
    init(ticker: String, companyName: String, numEmployees: Int, exchange: String, industry: String, website: String, description: String, CEO: String, tags: [String], address: String, state: String, city: String, zip: String, country: String, phone: String) {
        self.ticker = ticker
        self.companyName = companyName
        self.numEmployees = numEmployees
        self.exchange = exchange
        self.industry = industry
        self.website = website
        self.description = description
        self.CEO = CEO
        self.tags = tags
        self.address = address
        self.state = state
        self.city = city
        self.zip = zip
        self.country = country
        self.phone = phone
    }
    
    func truncateExchangeName() {
        if self.exchange == "NEW YORK STOCK EXCHANGE, INC." {
            self.exchange = "NYSE"
            return
        }
        var shortenedExchange = ""
        for char in self.exchange {
            if char == "/" || char == "(" {
                break
            }
            shortenedExchange.append(char)
        }
        self.exchange = shortenedExchange
    }
    
    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case companyName = "companyName"
        case numEmployees = "employees"
        case exchange = "exchange"
        case industry = "industry"
        case website = "website"
        case description = "description"
        case CEO = "CEO"
        case tags = "tags"
        case address = "address"
        case state = "state"
        case city = "city"
        case zip = "zip"
        case country = "country"
        case phone = "phone"
    }
}
