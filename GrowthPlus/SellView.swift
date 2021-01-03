//
//  SellView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import PopupView
import SwiftUI

struct SellView: View {
    @ObservedObject var wallet: Portfolio
    init() {
        wallet = Portfolio.shared
    }

    @State var sharesToSell: String = ""
    @State var showInputTypeAlert = false
    @State var showInvalidSharesNumberAlert = false
    @State var showSuccess = false
    @State var successMessage = ""

    var body: some View {
        // Sell Section
        VStack {
            Text("Sell \(wallet.selectedCard.ticker)")
                .font(primaryFont(size: 20))
                .fontWeight(.medium)
            Spacer()
            // Number of Shares
            HStack {
                Text("Number of Shares")
                    .font(primaryFont(size: 14))
                Spacer()
                TextField("0", text: $sharesToSell)
                    .multilineTextAlignment(.trailing)
                    .textContentType(.creditCardNumber)
                    .font(Font.custom("DIN-D", size: 16.0))
            }
            Divider()
            // Market Price
            HStack {
                Text("Market Price")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: wallet.selectedCard.currentPrice))
                    .font(Font.custom("DIN-D", size: 16.0))
                    .fontWeight(.medium)
            }

            Divider()
            // Purchase Estimated Cost
            HStack {
                Text("Estimated Credit")
                    .font(primaryFont(size: 14))
                    .fontWeight(.medium)
                Spacer()
                Text(DollarString(value: Double(Int(sharesToSell) ?? 0) * wallet.selectedCard.currentPrice))
                    .font(Font.custom("DIN-D", size: 18.0))
                    .fontWeight(.medium)
            }
            Divider()
            Button(action: {
                if let numShares = Int(sharesToSell), numShares > 0 {
                    print(numShares)
                    print("available: \(wallet.selectedCard.shares)")
                    if numShares > wallet.selectedCard.shares {
                        self.showInvalidSharesNumberAlert = true
                    } else {
                        self.successMessage = "Successfully sold \(numShares) shares of \(wallet.selectedCard.ticker)"
                        wallet.sellShare(ticker: wallet.selectedCard.ticker, shares: numShares, salePrice: wallet.selectedCard.currentPrice, avgPrice: wallet.selectedCard.avgCost)
                        self.showSuccess = true
                    }
                } else {
                    self.showInputTypeAlert = true
                }
                self.hideKeyboard()
            }, label: {
                Text("Sell")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.primaryColor))
                    .frame(minWidth: 200)
                    .foregroundColor(.white)
                    .font(primaryFont(size: 18))
            }).buttonStyle(PlainButtonStyle())
        }
        .popup(isPresented: $showInvalidSharesNumberAlert) {
            ShowSalePopupView(popupResult: .invalidNumberOfShares, message: "You can sell at most \(wallet.selectedCard.shares) shares of \(wallet.selectedCard.ticker)")
                .opacity(showInvalidSharesNumberAlert ? 1.0 : 0.0)
        }

        .popup(isPresented: $showSuccess) {
            ShowSalePopupView(popupResult: .success, message: successMessage)
                .opacity(showSuccess ? 1.0 : 0.0)
        }

        .popup(isPresented: $showInputTypeAlert) {
            ShowSalePopupView(popupResult: .inputTypeError, message: "Invalid number of shares to sell. Please check your input.")
                .opacity(showInputTypeAlert ? 1.0 : 0.0)
        }
    }

    func ShowSalePopupView(popupResult: SellResponseCode, message: String) -> some View {
        VStack(spacing: 10) {
            Text(popupResult.description)
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            Text(message)
                .font(primaryFont(size: 13))
                .foregroundColor(.white)
                .lineLimit(3)
                .minimumScaleFactor(0.001)
                .frame(minHeight: 60)
                .multilineTextAlignment(.center)
                .scaledToFit()
            Spacer()
            Button(action: {
                // Set all flags to false
                self.showSuccess = false
                self.showInvalidSharesNumberAlert = false
                self.showInputTypeAlert = false
            }) {
                Text("Dismiss")
                    .font(primaryFont(size: 14))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 40)
            .background(CustomColors.shared.secondaryColor)
            .cornerRadius(10)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .frame(width: 300, height: 300)
        .background(CustomColors.shared.primaryColor)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
}

struct SellView_Previews: PreviewProvider {
    static var previews: some View {
        SellView()
    }
}

enum SellResponseCode: CustomStringConvertible {
    case success
    case invalidNumberOfShares
    case inputTypeError

    var description: String {
        switch self {
        case .success:
            return "Sale Confirmation"
        case .invalidNumberOfShares:
            return "Invalid Number of Shares"
        case .inputTypeError:
            return "Invalid Input"
        }
    }
}
