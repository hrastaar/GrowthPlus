//
//  ColorSelectionView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI

struct ColorSelectionView: View {
    @State private var selectedPrimaryColor: Color = CustomColors.shared.primaryColor
    @State private var selectedSecondaryColor: Color = CustomColors.shared.secondaryColor
    @State private var presentSavedColorAlert: Bool = false
    @State private var presentResetToDefaultAlert: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("Customize In-App Colors")
                    .font(Font.custom("AppleColorEmoji", size: 24.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
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
                self.presentSavedColorAlert = true
            }, label: {
                Text("Save Color Palette")
                    .font(Font.custom("AppleColorEmoji", size: 20.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            }).alert(isPresented: $presentSavedColorAlert, content: {
                Alert(title:
                    Text("Saved your Color Preferences!")
                        .font(Font.custom("DIN-D", size: 24.0)),
                    message: Text("Your custom color palette selection has been saved. To update in-app colors, please close GrowthPlus and relaunch"),
                    dismissButton:
                    .default(
                        Text("Dismiss")
                            .font(Font.custom("DIN-D", size: 22.0))
                    ))
            }) // end of alert

            Spacer()

            Button(action: {
                CustomColors.shared.resetColors()
                self.presentResetToDefaultAlert = true
            }, label: {
                Text("Reset to Default")
                    .font(Font.custom("AppleColorEmoji", size: 20.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(CustomColors.shared.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(.white)
            }).alert(isPresented: $presentResetToDefaultAlert, content: {
                Alert(title:
                    Text("Color Palette has been reset to default")
                        .font(Font.custom("DIN-D", size: 24.0)),
                    message: Text("Your custom color palette selection has been saved. To update in-app colors, please close GrowthPlus and relaunch"),
                    dismissButton:
                    .default(
                        Text("Dismiss")
                            .font(Font.custom("AppleColorEmoji", size: 22.0))
                    ))
            }) // end of alert

        }.padding()
    }
}

struct ColorSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectionView()
    }
}
