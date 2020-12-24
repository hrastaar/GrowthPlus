//
//  CustomColors.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/19/20.
//

import SwiftUI
import RealmSwift
import Hex

class CustomColors: ObservableObject {
    
    static let shared = CustomColors()
    var primaryColor: Color
    var secondaryColor: Color
    var realmColorPalette: RealmColorPalette?
    init() {
        let realm = try! Realm()
        let realmColorArray: Array<RealmColorPalette> = Array(realm.objects(RealmColorPalette.self))
        if realmColorArray.count > 0 {
            print("loaded saved colors. Hex: \(realmColorArray[0].primaryColor), \(realmColorArray[0].secondaryColor)")
            self.realmColorPalette = realmColorArray[0]
            self.primaryColor = Color(UIColor(hex: realmColorArray[0].primaryColor))
            self.secondaryColor = Color(UIColor(hex: realmColorArray[0].secondaryColor))
            print("initialized with custom colors!")
        } else {
            // set to defaults
            self.primaryColor = Color(UIColor(hex: "#1ce4ac"))
            self.secondaryColor = Color(UIColor(hex: "424B54"))
            self.realmColorPalette = RealmColorPalette()
            realmColorPalette?.primaryColor = UIColor(primaryColor).htmlRGBColor
            realmColorPalette?.secondaryColor = UIColor(secondaryColor).htmlRGBColor
            print("\(UIColor(primaryColor).htmlRGBColor), \(UIColor(secondaryColor).htmlRGBColor)")
            try! realm.write {
                realm.add(realmColorPalette!)
                print("saved initial color palette")
            }
            print("Initialized with default colors")
        }
    }
    
    func updatePrimaryColor(color: UIColor) {
        self.primaryColor = Color(color)
        print("Saved primaryColor to update primary color to \(color.htmlRGBColor)")
        let realm: Realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.primaryColor = color.htmlRGBColor
            print("Successfully saved primary color to realm as \(String(describing: self.realmColorPalette?.primaryColor))")
        }
    }
    
    func updateSecondaryColor(color: UIColor) {
        self.secondaryColor = Color(color)
        print("Saved secondary color to \(color.htmlRGBColor)")
        let realm: Realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.secondaryColor = color.htmlRGBColor
            print("Successfully saved secondary color in realm to \(String(describing: self.realmColorPalette?.secondaryColor))")
        }
    }
    
    func resetColors() {
        self.primaryColor = Color(UIColor(hex: "#1ce4ac"))
        self.secondaryColor = Color(UIColor(hex: "424B54"))
        let realm: Realm = try! Realm()
        try! realm.write {
            realmColorPalette?.primaryColor = "#1ce4ac"
            realmColorPalette?.secondaryColor = "424B54"
        }
    }

}
