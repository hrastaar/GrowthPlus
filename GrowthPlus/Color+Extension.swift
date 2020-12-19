//
//  Color+Extension.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI
import RealmSwift
import Hex

class CustomColors {
    
    static let shared = CustomColors()
    var primaryColor: Color
    var secondaryColor: Color
    var realmColorPalette: RealmColorPalette?
    init() {
        let realm = try! Realm()
        let realmColorArray = Array(realm.objects(RealmColorPalette.self))
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
        print("Trying to update primary color to \(color.htmlRGBColor)")
        self.primaryColor = Color(color)
        let realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.primaryColor = color.htmlRGBColor
            print("Saved primary color to realm as \(String(describing: self.realmColorPalette?.primaryColor))")
        }
    }
    
    func updateSecondaryColor(color: UIColor) {
        print("trying to update secondary color to \(color.htmlRGBColor)")
        self.secondaryColor = Color(color)
        let realm = try! Realm()
        try! realm.write {
            self.realmColorPalette?.secondaryColor = color.htmlRGBColor
            print("Saved secondary color to realm as \(String(describing: self.realmColorPalette?.secondaryColor))")
        }
    }
    
    func resetColors() {
        self.primaryColor = Color(UIColor(hex: "#1ce4ac"))
        self.secondaryColor = Color(UIColor(hex: "424B54"))
        let realm = try! Realm()
        try! realm.write {
            realmColorPalette?.primaryColor = "#1ce4ac"
            realmColorPalette?.secondaryColor = "424B54"
        }
    }

}

func profitLossColor(inputDouble: Double) -> Color {
    return inputDouble >= 0 ? .green : .red
}

func DollarString(value: Double) -> String {
    if value >= 0.00 {
        return String(format: "$%.2f", value)
    } else {
        let absoluteValue = abs(value) // get absolute value, and place negative sign prior to $
        return String(format: "-$%.2f", absoluteValue)
    }
}

extension Font {
    func primaryFont(size: CGFloat) -> Font {
        return Font.custom("DIN-D", size: size)
    }
}

extension UIColor {
     func toString() -> String {
          let colorRef = self.cgColor
          return CIColor(cgColor: colorRef).stringRepresentation
     }
 }

extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    // hue, saturation, brightness and alpha components from UIColor**
    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    var htmlRGBColor:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    var htmlRGBaColor:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
}
