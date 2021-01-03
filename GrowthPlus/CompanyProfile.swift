//
//  CompanyProfile.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/26/20.
//

import Foundation

class CompanyProfile: ObservableObject, Decodable {
    var ticker: String
    var companyName: String
    var numEmployees: Int? = 0
    var exchange: String? = "Exchange N/A"
    var industry: String? = ""
    var website: String
    var description: String? = "Description unavailable"
    var CEO: String
    var tags: [String]? = []
    // Address / Contact Info
    var address: String? = ""
    var state: String? = ""
    var city: String? = ""
    var zip: String? = ""
    var country: String? = ""
    var phone: String? = ""
    var isValidProfile: Bool {
        !ticker.isEmpty
    }

    func addressAvailable() -> Bool {
        if let _ = address,
           let _ = state,
           let _ = city,
           let _ = zip
        {
            return true
        } else {
            return false
        }
    }

    var success: Bool? {
        !ticker.isEmpty && !companyName.isEmpty
    }

    init() {
        ticker = ""
        companyName = ""
        numEmployees = 0
        exchange = ""
        industry = ""
        website = ""
        description = ""
        CEO = ""
        tags = [String]()
        address = ""
        state = ""
        city = ""
        zip = ""
        country = ""
        phone = ""
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
        if let exchange = self.exchange {
            if exchange == "NEW YORK STOCK EXCHANGE, INC." {
                self.exchange = "NYSE"
                return
            }
            var shortenedExchange = ""
            for char in exchange {
                if char == "/" || char == "(" {
                    break
                }
                shortenedExchange.append(char)
            }
            self.exchange = shortenedExchange
        }
    }

    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case companyName
        case numEmployees = "employees"
        case exchange
        case industry
        case website
        case description
        case CEO
        case tags
        case address
        case state
        case city
        case zip
        case country
        case phone
    }
}
