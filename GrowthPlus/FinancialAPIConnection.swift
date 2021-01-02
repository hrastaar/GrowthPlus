//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import Alamofire
import SwiftyJSON

final class FinancialAPIConnection: ObservableObject {
    
    // Search Page Data Sets
    @Published var searchResults = [SearchResult]() // Search results when user searches a symbol
    
    // Stock Page Data Sets
    @Published var stockNewsArticles = [StockNewsArticle]() // Array of articles associated with a current stock page
    @Published var stockPageData = StockPageData() // Stock data for the StockPageView
    @Published var stockChartPoints = [StockChartPoint]() // Chart points used to draw up daily performance
    @Published var stockEarnings = [Earnings]() // Array of past earnings
    
    // Stock Company Profile Popup Data Sets
    @Published var companyProfile = CompanyProfile() // Stock Company Profile for the popup (if available)
    
    // Discover Page Data Sets
    @Published var dailySectorPerformancesList = [SectorPerformance]() // Array of sector performances
    @Published var dailyMostActiveStocksList = [StockListData]()
    @Published var dailyBestPerformingStocksList = [StockListData]()
    @Published var dailyWorstPerformingStocksList = [StockListData]()
    @Published var portfolioHoldingsNewsArticlesList = [StockNewsArticle]()
    
    static let shared = FinancialAPIConnection() // Singleton element used to control data gathered
    
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
    
    public func getDiscoveryPageData() {
        if self.dailySectorPerformancesList.isEmpty {
            self.fetchSectorPerformances()
        }
        self.initializeHoldingsNewsArticles()
        self.fetchDailyListStocks()
    }
    
    public func fetchStockPageData(ticker: String, numEarningsReports: Int? = 4) {
        self.fetchStockData(ticker: ticker)
        self.fetchCompanyProfile(ticker: ticker)
        self.fetchNewsArticles(ticker: ticker)
        self.gatherChartPoints(ticker: ticker)
    }

    // PRIVATE FINANCIAL TOOL FUNCTIONALITIES
    
    // Gather Stock Data for Ticker
    private func fetchStockData(ticker: String) {
        self.stockPageData = StockPageData()
        // build get request
        let fetchStockDataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockPageRequest: DataRequest = AF.request(fetchStockDataURL)
        stockPageRequest.responseJSON { data in
            if let currData = data.data {
                do {
                    let stockPageData = try JSONDecoder().decode(StockPageData.self, from: currData)
                    stockPageData.truncateExchangeName()
                    self.stockPageData = stockPageData
                    return
                } catch {
                    print("Error using JSONDecoder to parse StockPageData type for stock symbol: \(ticker)")
                }
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
                do {
                    let companyProfile = try JSONDecoder().decode(CompanyProfile.self, from: profileData)
                    companyProfile.truncateExchangeName()
                    print(companyProfile)
                    self.companyProfile = companyProfile
                } catch {
                    print("Error with JSONDecoder")
                }
            }
        }
    }
    
    private func fetchSectorPerformances() {
        self.dailySectorPerformancesList.removeAll()
        let sectorPerformanceURLString: String = "https://cloud.iexapis.com/stable/stock/market/sector-performance?token=pk_c154ec9b3d75402bb77e126b940ed4ca"
        let sectorPerformanceURL: URL = URL(string: sectorPerformanceURLString)!
        let sectorPerformanceDataRequest: DataRequest = AF.request(sectorPerformanceURL)
        sectorPerformanceDataRequest.responseJSON { data in
            if let performanceData = data.data {
                do {
                    let sectorPerformanceArray: [SectorPerformance] = try JSONDecoder().decode([SectorPerformance].self, from: performanceData)
                    self.dailySectorPerformancesList = sectorPerformanceArray
                } catch {
                    print("Error fetching sector performances.")
                }
            }
        }
    }
    
    /// NOT READY FOR PRODUCTION. As of Dec. 30, IEXCloud is in the process of finding a provider for this data set
    private func fetchAnalystRecommendations(ticker: String) {
        let recommendationURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/recommendation-trends?token=pk_c154ec9b3d75402bb77e126b940ed4ca"
        let recommendationURL = URL(string: recommendationURLString)!
        let recommendationDataRequest: DataRequest = AF.request(recommendationURL)
        recommendationDataRequest.responseJSON { data in
            if let analystData = data.data {
                let json = JSON(analystData)
                print(json)
            }
        }
    }
    
    // gather all news articles for stocks in holdings and sort by date
    private func initializeHoldingsNewsArticles() {
        self.portfolioHoldingsNewsArticlesList.removeAll()
        let portfolioRef = Portfolio.shared
        for card in portfolioRef.portfolioCards {
            let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(card.ticker)/news/latest/3?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
            let articleAPIRequest: DataRequest = AF.request(url)
            articleAPIRequest.responseJSON { data in
                do {
                    if let articleData = data.data {
                        var articleObjectArray: [StockNewsArticle] = try JSONDecoder().decode([StockNewsArticle].self, from: articleData)
                        articleObjectArray.removeAll(where: {$0.language != "en"})
                        self.portfolioHoldingsNewsArticlesList.append(contentsOf: articleObjectArray)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        self.portfolioHoldingsNewsArticlesList.sort { (a, b) -> Bool in
            a.date < b.date
        }
    }
    
    private func fetchDailyListStocks() {
        fetchMostActiveStocks()
        fetchDailyGainers()
        fetchDailyLosers()
    }
    
    private func fetchMostActiveStocks() {
        self.dailyMostActiveStocksList.removeAll()
        let mostActiveURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let mostActiveDataRequest: DataRequest = AF.request(mostActiveURL)
        mostActiveDataRequest.responseJSON { data in
            if let currData = data.data {
                let json = JSON(currData)
                let jsonToArray = json.arrayValue
                for point in jsonToArray {
                    let ticker = point["symbol"].stringValue
                    let companyName = point["companyName"].stringValue
                    let dailyChange = point["change"].doubleValue
                    let percentChange = point["changePercent"].doubleValue
                    let stockListElement = StockListData(ticker: ticker, companyName: companyName, percentChange: percentChange, dailyChange: dailyChange)
                    self.dailyMostActiveStocksList.append(stockListElement)
                }
            }
        }
    }
    
    private func fetchDailyGainers() {
        self.dailyBestPerformingStocksList.removeAll()
        let gainerListURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let gainerDataRequest: DataRequest = AF.request(gainerListURL)
        gainerDataRequest.responseJSON { data in
            if let currData = data.data {
                let json = JSON(currData)
                let jsonToArray = json.arrayValue
                for point in jsonToArray {
                    let ticker = point["symbol"].stringValue
                    let companyName = point["companyName"].stringValue
                    let dailyChange = point["change"].doubleValue
                    let percentChange = point["changePercent"].doubleValue
                    let stockListElement = StockListData(ticker: ticker, companyName: companyName, percentChange: percentChange, dailyChange: dailyChange)
                    self.dailyBestPerformingStocksList.append(stockListElement)
                }
            }
        }
    }
    
    private func fetchDailyLosers() {
        self.dailyWorstPerformingStocksList.removeAll()
        let loserListURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/losers?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let loserDataRequest: DataRequest = AF.request(loserListURL)
        loserDataRequest.responseJSON { data in
            if let currData = data.data {
                let json = JSON(currData)
                let jsonToArray = json.arrayValue
                for point in jsonToArray {
                    let ticker = point["symbol"].stringValue
                    let companyName = point["companyName"].stringValue
                    let dailyChange = point["change"].doubleValue
                    let percentChange = point["changePercent"].doubleValue
                    let stockListElement = StockListData(ticker: ticker, companyName: companyName, percentChange: percentChange, dailyChange: dailyChange)
                    self.dailyWorstPerformingStocksList.append(stockListElement)
                }
            }
        }
    }
    

}
