//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import SwiftUI
import Alamofire
import SwiftyJSON

final class FinancialAPIConnection: ObservableObject {
    // Search Page Data Sets
    @Published var searchResults = [SearchResult]() // Search results when user searches a symbol

    // Stock Page Data Sets
    @Published var stockNewsArticles = [StockNewsArticle]() // Array of articles associated with a current stock page
    @Published var stockPageData = StockDetailData() // Stock data for the StockPageView
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

    @Published var cryptocurrencyDictionary = [String: CryptocurrencyData]()
    private let IEX_CLOUD_API_KEY = "pk_c154ec9b3d75402bb77e126b940ed4ca"
    static let shared = FinancialAPIConnection() // Singleton element used to control data gathered

    // Gather List of Search Results for Ticker
    public func searchTicker(ticker: String, exchange _: String?) {
        searchResults.removeAll()
        let stockTickerSearchURL = URL(string: "https://cloud.iexapis.com/stable/search/\(ticker)?token=\(IEX_CLOUD_API_KEY)")!
        let stockTickerSearchRequest: DataRequest = AF.request(stockTickerSearchURL)
        stockTickerSearchRequest.responseJSON { data in
            do {
                if let responseData = data.data {
                    var searchResults: [SearchResult] = try JSONDecoder().decode([SearchResult].self, from: responseData)
                    searchResults.removeAll(where: { $0.region != "US" })
                    searchResults.removeAll(where: { $0.companyName.isEmpty || $0.ticker.isEmpty })
                    self.searchResults = Array(searchResults.prefix(10))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    public func getDiscoveryPageData(streamCredits: Int = 3) {
        if dailySectorPerformancesList.isEmpty {
            fetchSectorPerformances()
        }
        streamCryptoTicker(ticker: "btcusdt", streamCredits: streamCredits)
        streamCryptoTicker(ticker: "ethusd", streamCredits: streamCredits)
        initializeHoldingsNewsArticles()
        fetchDailyListStocks()
    }

    public func getCompleteStockData(ticker: String, numEarningsReports _: Int? = 4) {
        getStockQuoteData(ticker: ticker)
        getCompanyProfileData(ticker: ticker)
        fetchNewsArticles(ticker: ticker)
        gatherChartPoints(ticker: ticker)
    }

    // PRIVATE FINANCIAL TOOL FUNCTIONALITIES
    
    // Create an open stream that fetches cryptocurrency values
    private func streamCryptoTicker(ticker: String, streamCredits: Int = 3) {
        var credits = streamCredits
        let urlString = "https://cloud-sse.iexapis.com/stable/cryptoQuotes?symbols=\(ticker)&token=\(IEX_CLOUD_API_KEY)"
        AF.streamRequest(urlString).responseStream { stream in
            switch stream.event {
            case let .stream(result):
                switch result {
                case let .success(data):
                    credits -= 1
                    print("decremented api calls available for cryptocurrencies to ", credits)
                    if credits <= 0 {
                        print("Ran out of API calls for crypto streaming.")
                        stream.cancel()
                    }
                    do {
                        let dataStreamString = Array(String(data: data, encoding: .utf8) ?? "")
                        var apiDataString = ""
                        for i in 6 ..< dataStreamString.count - 2 {
                            apiDataString.append(dataStreamString[i])
                        }
                        // print(stringBuilder)
                        let cryptoJSON = try JSON(data: apiDataString.data(using: .utf8) ?? Data())
                        if let arrayOfData = cryptoJSON.array,
                           let currentCryptoData = arrayOfData.first
                        {
                            print(currentCryptoData)
                            if let title = currentCryptoData["symbol"].string,
                               let price = currentCryptoData["latestPrice"].string,
                               let date = currentCryptoData["latestUpdate"].int
                            {
                                self.cryptocurrencyDictionary[ticker] = CryptocurrencyData(ticker: title, price: price, date: date)
                            }
                        }
                    } catch {
                        print("failed to parse data as json")
                        print(error.localizedDescription)
                    }
                }
            case let .complete(completion):
                print(completion)
            }
        }
    }
    
    // Gather Stock Data for Ticker
    private func getStockQuoteData(ticker: String) {
        stockPageData = StockDetailData()
        // build get request
        let fetchStockDataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=\(IEX_CLOUD_API_KEY)")!
        let stockPageRequest: DataRequest = AF.request(fetchStockDataURL)
        stockPageRequest.responseJSON { data in
            if let currData = data.data {
                print(JSON(currData))
                do {
                    let stockPageData = try JSONDecoder().decode(StockDetailData.self, from: currData)
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
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/news?token=\(IEX_CLOUD_API_KEY)")!
        let articleAPIRequest: DataRequest = AF.request(url)
        articleAPIRequest.responseJSON { data in
            do {
                if let articleData = data.data {
                    var articleObjectArray: [StockNewsArticle] = try JSONDecoder().decode([StockNewsArticle].self, from: articleData)
                    articleObjectArray.removeAll(where: { $0.language != "en" })
                    self.stockNewsArticles = articleObjectArray
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func gatherChartPoints(ticker: String) {
        stockChartPoints.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable//stock/\(ticker)/intraday-prices?token=\(IEX_CLOUD_API_KEY)")!
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
        let earningsURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/earnings/\(numberOfReports!)?token=\(IEX_CLOUD_API_KEY)"
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

    private func getCompanyProfileData(ticker: String) {
        let companyProfileURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/company?token=\(IEX_CLOUD_API_KEY)"
        let companyProfileURL = URL(string: companyProfileURLString)!
        let companyProfileDataRequest: DataRequest = AF.request(companyProfileURL)
        companyProfileDataRequest.responseJSON { data in
            if let profileData = data.data {
                do {
                    let companyProfile = try JSONDecoder().decode(CompanyProfile.self, from: profileData)
                    companyProfile.truncateExchangeName()
                    self.companyProfile = companyProfile
                } catch {
                    print("Error with JSONDecoder")
                }
            }
        }
    }

    private func fetchSectorPerformances() {
        dailySectorPerformancesList.removeAll()
        let sectorPerformanceURLString: String = "https://cloud.iexapis.com/stable/stock/market/sector-performance?token=\(IEX_CLOUD_API_KEY)"
        let sectorPerformanceURL = URL(string: sectorPerformanceURLString)!
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
        let recommendationURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/recommendation-trends?token=\(IEX_CLOUD_API_KEY)"
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
        portfolioHoldingsNewsArticlesList.removeAll()
        let portfolioRef = PortfolioManager.shared
        for card in portfolioRef.portfolioCards {
            let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(card.ticker)/news/latest/3?token=\(IEX_CLOUD_API_KEY)")!
            let articleAPIRequest: DataRequest = AF.request(url)
            articleAPIRequest.responseJSON { data in
                do {
                    if let articleData = data.data {
                        var articleObjectArray: [StockNewsArticle] = try JSONDecoder().decode([StockNewsArticle].self, from: articleData)
                        articleObjectArray.removeAll(where: { $0.language != "en" })
                        self.portfolioHoldingsNewsArticlesList.append(contentsOf: articleObjectArray)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        portfolioHoldingsNewsArticlesList.sort { (a, b) -> Bool in
            a.date < b.date
        }
    }

    private func fetchDailyListStocks() {
        fetchMostActiveStocks()
        fetchDailyGainers()
        fetchDailyLosers()
    }

    private func fetchMostActiveStocks() {
        dailyMostActiveStocksList.removeAll()
        let mostActiveURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=\(IEX_CLOUD_API_KEY)")!
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
        dailyBestPerformingStocksList.removeAll()
        let gainerListURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/gainers?token=\(IEX_CLOUD_API_KEY)")!
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
        dailyWorstPerformingStocksList.removeAll()
        let loserListURL = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/losers?token=\(IEX_CLOUD_API_KEY)")!
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
