//
//  IndividualTechnologyView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI

struct IndividualTechnologyView: View {
    let technology: TechnologyData

    @ObservedObject var customColor = AppColorManager.shared

    var body: some View {
        VStack {
            Spacer(minLength: 15)
            Text(technology.technologyName)
                .fontWeight(.bold)
                .font(primaryFont(size: 20))
                .foregroundColor(.black)
            Image(technology.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200.0, height: 200)
                .cornerRadius(15)
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Text(technology.description)
                    .font(primaryFont(size: 14))
                    .fontWeight(.semibold)
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Spacer()
            }
            Spacer()
        }.frame(width: UIScreen.main.bounds.width * 0.67, height: 400)
            .background(Color.white)
            .cornerRadius(15)
    }
}

struct IndividualTechnologyView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualTechnologyView(technology: technologies[0])
    }
}
