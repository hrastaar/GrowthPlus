//
//  AppColorManager.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import Hex
import RealmSwift
import SwiftUI

class AppColorManager: ObservableObject {
    static let shared = AppColorManager() // Used as a singleton throughout app lifecycle

    @Published var primaryColor: Color
    @Published var secondaryColor: Color

    var realmColorPalette: RealmColorPalette?
    init() {
        let realm = try! Realm()
        let realmColorArray: [RealmColorPalette] = Array(realm.objects(RealmColorPalette.self))
        if !realmColorArray.isEmpty {
            realmColorPalette = realmColorArray[0]
            primaryColor = Color(UIColor(hex: realmColorArray[0].primaryColor))
            secondaryColor = Color(UIColor(hex: realmColorArray[0].secondaryColor))
        } else {
            // set to defaults
            primaryColor = Color(UIColor(hex: "#1ce4ac"))
            secondaryColor = Color(UIColor(hex: "424B54"))
            realmColorPalette = RealmColorPalette()
            realmColorPalette?.primaryColor = UIColor(primaryColor).htmlRGBColor
            realmColorPalette?.secondaryColor = UIColor(secondaryColor).htmlRGBColor
            try! realm.write {
                realm.add(realmColorPalette!)
                print("saved initial color palette")
            }
            print("Initialized with default colors")
        }
    }

    func updatePrimaryColor(color: UIColor) {
        primaryColor = Color(color)
        print("Saved primaryColor to update primary color to \(color.htmlRGBColor)")
        let realm: Realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.primaryColor = color.htmlRGBColor
            print("Successfully saved primary color to realm as \(String(describing: self.realmColorPalette?.primaryColor))")
        }
    }

    func updateSecondaryColor(color: UIColor) {
        secondaryColor = Color(color)
        print("Saved secondary color to \(color.htmlRGBColor)")
        let realm: Realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.secondaryColor = color.htmlRGBColor
            print("Successfully saved secondary color in realm to \(String(describing: self.realmColorPalette?.secondaryColor))")
        }
    }

    func getPrimaryBackgroundTextColor() -> Color {
        let primaryUIColor = UIColor(primaryColor)
        if let isLight = primaryUIColor.isLight() {
            if isLight, primaryUIColor != UIColor(hex: "#1ce4ac") {
                return .black
            } else {
                return .white
            }
        }
        return .white
    }

    func getSecondaryBackgroundTextColor() -> Color {
        let secondaryUIColor = UIColor(secondaryColor)
        if let isLight = secondaryUIColor.isLight() {
            if isLight, secondaryUIColor != UIColor(hex: "#1ce4ac") {
                return .black
            } else {
                return .white
            }
        }
        return .white
    }

    func resetColors() {
        primaryColor = Color(UIColor(hex: "#1ce4ac"))
        secondaryColor = Color(UIColor(hex: "424B54"))
        let realm: Realm = try! Realm()
        try! realm.write {
            realmColorPalette?.primaryColor = "#1ce4ac"
            realmColorPalette?.secondaryColor = "424B54"
        }
    }
}
