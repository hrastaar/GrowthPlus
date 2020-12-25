//
//  MenuUtilitiesView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/23/20.
//

import SwiftUI

struct MenuUtilitiesView: View {
    let customColors = CustomColors.shared

    var body: some View {
        HStack {
            NavigationLink(
                destination: SettingsView(),
                label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(customColors.primaryColor)
                        .cornerRadius(10)
                }
            )
            Spacer()
            NavigationLink(
                destination: SearchStockView(),
                label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(customColors.primaryColor)
                        .cornerRadius(10)
                }
            )
        }
    }
}

struct MenuUtilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        MenuUtilitiesView()
    }
}
