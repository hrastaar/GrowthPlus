//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import Alamofire
import SwiftyJSON

final class FinancialAPIConnection: ObservableObject {
    @Published var searchResults = [SearchResult]()
    @Published var stockNewsArticles = [StockNewsArticle]()
    @Published var stockPageData = StockPageData()
    @Published var companyProfile = CompanyProfile()
    @Published var stockChartPoints = [StockChartPoint]()
    @Published var stockEarnings = [Earnings]()
    
    static let shared = FinancialAPIConnection()
    // Gather List of Search Results for Ticker
    public func searchTicker(ticker: String, exchange _: String?) {
        self.searchResults.removeAll()
        let stockTickerSearchURL = URL(string: "https://cloud.iexapis.com/stable/search/\(ticker)?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockTickerSearchRequest: DataRequest = AF.request(stockTickerSearchURL)
        stockTickerSearchRequest.responseJSON { data in
            do {
                if let responseData = data.data {
                    var searchResults: [SearchResult] = try JSONDecoder().decode([SearchResult].self, from: responseData)
                    searchResults.removeAll(where: { $0.region != "US" })
                    searchResults.removeAll(where: { $0.companyName.isEmpty || $0.ticker.isEmpty})
                    self.searchResults = Array(searchResults.prefix(10))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchStockPageData(ticker: String, numEarningsReports: Int? = 4) {
        self.fetchStockData(ticker: ticker)
        self.fetchCompanyProfile(ticker: ticker)
        self.fetchNewsArticles(ticker: ticker)
        self.gatherChartPoints(ticker: ticker)
        //self.fetchEarningsReports(ticker: ticker, numberOfReports: numEarningsReports)
    }

    // PRIVATE FINANCIAL TOOL FUNCTIONALITIES
    
    // Gather Stock Data for Ticker
    private func fetchStockData(ticker: String) {
        // build get request
        let fetchStockDataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockPageRequest: DataRequest = AF.request(fetchStockDataURL)
        stockPageRequest.responseJSON { data in
            do {
                if let currData = data.data {
                    let stockPageData = try JSONDecoder().decode(StockPageData.self, from: currData)
                    stockPageData.truncateExchangeName()
                    self.stockPageData = stockPageData
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func fetchNewsArticles(ticker: String) {
        stockNewsArticles.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/news?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let articleAPIRequest: DataRequest = AF.request(url)
        articleAPIRequest.responseJSON { data in
            do {
                if let articleData = data.data {
                    var articleObjectArray: [StockNewsArticle] = try JSONDecoder().decode([StockNewsArticle].self, from: articleData)
                    articleObjectArray.removeAll(where: {$0.language != "en"})
                    self.stockNewsArticles = articleObjectArray
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func gatherChartPoints(ticker: String) {
        stockChartPoints.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable//stock/\(ticker)/intraday-prices?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let chartDataRequest: DataRequest = AF.request(url)
        chartDataRequest.responseJSON { data in
            if let chartData = data.data {
                let json = JSON(chartData)
                let jsonToArray = json.arrayValue
                for point in jsonToArray {
                    let time = point["label"].stringValue
                    let avgPrice = point["average"].doubleValue
                    let highPrice = point["high"].doubleValue
                    let lowPrice = point["low"].doubleValue
                    let chartPoint = StockChartPoint(timeLabel: time, avgPrice: avgPrice, highPrice: highPrice, lowPrice: lowPrice)
                    if chartPoint.avgPrice != 0.00 {
                        self.stockChartPoints.append(chartPoint)
                    }
                }
            }
        }
    }
    
    private func fetchEarningsReports(ticker: String, numberOfReports: Int? = 4) {
        stockEarnings.removeAll()
        let earningsURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/earnings/\(numberOfReports!)?token=pk_c154ec9b3d75402bb77e126b940ed4ca"
        let url = URL(string: earningsURLString)!
        let earningsDataRequest: DataRequest = AF.request(url)
        earningsDataRequest.responseJSON { data in
            do {
                if let earningsData = data.data {
                    let responseJSON: JSON = try JSON(data: earningsData)
                    let earningsData = try responseJSON["earnings"].rawData()
                    let earningsObjectArray: [Earnings] = try JSONDecoder().decode([Earnings].self, from: earningsData)
                    self.stockEarnings = earningsObjectArray
                    return
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchCompanyProfile(ticker: String) {
        let companyProfileURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/company?token=pk_c154ec9b3d75402bb77e126b940ed4ca"
        let companyProfileURL = URL(string: companyProfileURLString)!
        let companyProfileDataRequest: DataRequest = AF.request(companyProfileURL)
        companyProfileDataRequest.responseJSON { data in
            if let profileData = data.data {
                let json = JSON(profileData)
                let companyProfile = CompanyProfile()
                companyProfile.ticker = json["ticker"].stringValue
                companyProfile.companyName = json["companyName"].stringValue
                companyProfile.numEmployees = json["employees"].intValue
                companyProfile.exchange = json["exchange"].stringValue
                companyProfile.industry = json["industry"].stringValue
                companyProfile.website = json["website"].stringValue
                companyProfile.description = json["description"].stringValue
                companyProfile.CEO = json["CEO"].stringValue
                let tags = json["tags"].arrayObject
                companyProfile.tags = tags as! [String]
                companyProfile.address = json["address"].stringValue
                companyProfile.state = json["state"].stringValue
                companyProfile.city = json["city"].stringValue
                companyProfile.zip = json["zip"].stringValue
                companyProfile.country = json["country"].stringValue
                companyProfile.phone = json["phone"].stringValue
                companyProfile.truncateExchangeName()
                print(companyProfile)
                self.companyProfile = companyProfile
            }
        }
    }
}
