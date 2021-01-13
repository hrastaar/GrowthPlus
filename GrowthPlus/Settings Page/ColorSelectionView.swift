//
//  ColorSelectionView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI

struct ColorSelectionView: View {
    @ObservedObject var colorManager = AppColorManager.shared
    @State private var selectedPrimaryColor: Color = AppColorManager.shared.primaryColor
    @State private var selectedSecondaryColor: Color = AppColorManager.shared.secondaryColor
    @State private var presentSavedColorAlert: Bool = false
    @State private var presentResetToDefaultAlert: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("Customize In-App Colors")
                    .font(primaryFont(size: 24.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                Spacer()
            }
            LottieView(fileName: "painter", backgroundColor: colorManager.primaryColor)
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
                colorManager.updatePrimaryColor(color: UIColor(selectedPrimaryColor))
                colorManager.updateSecondaryColor(color: UIColor(selectedSecondaryColor))
                self.presentSavedColorAlert = true
            }, label: {
                Text("Save Color Palette")
                    .font(primaryFont(size: 20.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(colorManager.getSecondaryBackgroundTextColor())
            }).alert(isPresented: $presentSavedColorAlert, content: {
                Alert(title:
                    Text("Saved your Color Preferences!")
                        .font(Font.custom("DIN-D", size: 24.0)),
                    message: Text("Your custom color palette selection has been saved."),
                    dismissButton:
                    .default(
                        Text("Dismiss")
                            .font(Font.custom("DIN-D", size: 22.0))
                    ))
            }) // end of alert

            Spacer()

            Button(action: {
                self.colorManager.resetColors()
                self.presentResetToDefaultAlert = true
            }, label: {
                Text("Reset to Default")
                    .font(primaryFont(size: 20.0))
                    .minimumScaleFactor(0.001)
                    .lineLimit(1)
                    .padding()
                    .frame(minWidth: 300)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorManager.secondaryColor))
                    .cornerRadius(5)
                    .foregroundColor(colorManager.getSecondaryBackgroundTextColor())
            }).alert(isPresented: $presentResetToDefaultAlert, content: {
                Alert(title:
                    Text("Color Palette has been reset to default")
                        .font(Font.custom("DIN-D", size: 24.0)),
                    message: Text("Your custom color palette selection has been saved."),
                    dismissButton:
                    .default(
                        Text("Dismiss")
                            .font(primaryFont(size: 22.0))
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
