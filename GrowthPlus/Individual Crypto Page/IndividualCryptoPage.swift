//
//  IndividualCryptoPage.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/13/21.
//

import SwiftUI

struct IndividualCryptoPage: View {
    let ticker: String
    @ObservedObject var financialAPIConnection = FinancialAPIConnection.shared
    @State var cryptoData = FinancialAPIConnection.shared.cryptoData
    var body: some View {
        VStack {
            HStack {
                Text(cryptoData?.price ?? "NA")
                Spacer()
            }
            
        }
    }
}

struct IndividualCryptoPage_Previews: PreviewProvider {
    static var previews: some View {
        IndividualCryptoPage(ticker: "btcusd")
    }
}
