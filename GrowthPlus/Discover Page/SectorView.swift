//
//  SectorView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/30/20.
//

import SwiftUI

struct SectorView: View {
    let sector: SectorPerformance

    var body: some View {
        VStack {
            Text(sector.name)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.001)
                .lineLimit(2)
            Spacer()
            Text(sector.performanceString)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(width: 180, height: 100)
        .foregroundColor(.white)
        .background(sector.backgroundColor)
        .font(Font.custom("DIN-D", size: 18.0))
        .cornerRadius(15)
        .multilineTextAlignment(.center)
    }
}

struct SectorView_Previews: PreviewProvider {
    static var previews: some View {
        SectorView(sector: SectorPerformance(type: "sector", name: "Communication Services", performance: -0.00475, lastUpdated: 1609275600021))
    }
}
