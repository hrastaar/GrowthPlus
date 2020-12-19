//
//  Color+Extension.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI
import Hex

extension Color {
    static let primaryColor = Color(UIColor(hex: "#1ce4ac"))
    static let secondaryColor = Color(UIColor(hex: "424B54"))

}

func profitLossColor(inputDouble: Double) -> Color {
    return inputDouble >= 0 ? .green : .red
}

func DollarString(value: Double) -> String {
    if value >= 0.00 {
        return String(format: "$%.2f", value)
    } else {
        let absoluteValue = abs(value) // get absolute value, and place negative sign prior to $
        return String(format: "-$%.2f", absoluteValue)
    }
}

extension Font {
    func primaryFont(size: CGFloat) -> Font {
        return Font.custom("DIN-D", size: size)
    }
}
