//
//  RealmObjects.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import Foundation
import RealmSwift

class RealmStockData: Object {
    @objc dynamic var ticker: String = String()
    @objc dynamic var shares: Int = Int()
    @objc dynamic var avgCost: Double = Double()
}

class RealmPortfolio: Object {
    @objc dynamic let uuid: String = UUID().uuidString
    @objc dynamic var overallBalance: Double = 0.00 // changes when user sells stock holding
    var holdings: RealmSwift.List<RealmStockData> = RealmSwift.List<RealmStockData>()
}

class RealmColorPalette: Object {
    @objc dynamic var primaryColor: String = String()
    @objc dynamic var secondaryColor: String = String()
}
