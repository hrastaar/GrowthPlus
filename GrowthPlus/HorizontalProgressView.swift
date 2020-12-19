//
//  HorizontalProgressView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct HorizontalProgressView: View {
    @Binding var percentage: Int
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondaryColor)
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primaryColor)
                    .frame(width: proxy.size.width * CGFloat(percentage)/100, height: 20)
            }
        }
    }
}

struct HorizontalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalProgressView(percentage: .constant(50))
            
    }
}
