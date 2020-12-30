//
//  SectorView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import SwiftUI

struct SectorView: View {
    let sector: SectorPerformance
    let colorManager = CustomColors.shared

    var body: some View {
        VStack {
            Text(sector.name)
                .foregroundColor(UIColor(colorManager.primaryColor).isLight()! && colorManager.primaryColor != Color(UIColor(hex: "#1ce4ac")) ? Color.black : Color.white)
                .font(Font.custom("DIN-D", size: 24.0))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.001)
                .lineLimit(2)
            Spacer()
            Text(String(format: "%.2f%%", sector.performance * 100.00))
                .foregroundColor(UIColor(colorManager.primaryColor).isLight()! && colorManager.primaryColor != Color(UIColor(hex: "#1ce4ac")) ? Color.black : Color.white)
                .fontWeight(.bold)
                .font(Font.custom("DIN-D", size: 24.0))
            Spacer()
            Text(sector.dateString)
                .foregroundColor(UIColor(colorManager.primaryColor).isLight()! && colorManager.primaryColor != Color(UIColor(hex: "#1ce4ac")) ? Color.black : Color.white)
        }
        .padding(.vertical, 10)
        .frame(width: 230, height: 150)
        .background(sector.performance >= 0 ? Color(UIColor(hex: "#18F2B2")) : Color(UIColor(hex: "#DB5461")))
        .cornerRadius(15)
        .multilineTextAlignment(.center)
    }
}

struct SectorView_Previews: PreviewProvider {
    static var previews: some View {
        SectorView(sector: SectorPerformance(type: "sector", name: "Technology", performance: -0.00475, lastUpdated: 1609275600021))
    }
}
