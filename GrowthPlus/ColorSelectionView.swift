//
//  ColorSelectionView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI

struct ColorSelectionView: View {
    
    @State private var selectedPrimaryColor = CustomColors.shared.primaryColor
    @State private var selectedSecondaryColor = CustomColors.shared.secondaryColor
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Custom Colors for App")
                    .font(Font.custom("DIN-D", size: 26.0))
                Spacer()
            }
            LottieView(fileName: "painter", backgroundColor: selectedPrimaryColor)
                .frame(width: UIScreen.main.bounds.width - 25)
                .cornerRadius(10)
            HStack {
                ColorPicker(
                    "Pick a primary color",
                    selection: $selectedPrimaryColor
                )
                Spacer()
            }
            
            Divider()
            
            HStack {
                ColorPicker(
                    "Pick a secondary color",
                    selection: $selectedSecondaryColor
                )
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                print("Save Selection")
                CustomColors.shared.updatePrimaryColor(color: UIColor(selectedPrimaryColor))
                CustomColors.shared.updateSecondaryColor(color: UIColor(selectedSecondaryColor))
            }, label: {
                Text("Save Color Palette")
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            })
            
            Spacer()
            
            Button(action: {
                CustomColors.shared.resetColors()
                print("Resetting colors")
            }, label: {
                Text("Reset to Default")
                    .font(Font.custom("DIN-D", size: 22.0))
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            })
            
        }.padding()
    }
}

struct ColorSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectionView()
    }
}
