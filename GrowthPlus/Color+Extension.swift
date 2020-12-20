//
//  Color+Extension.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI
import Hex

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
    /// RGB String conversion material. Credited to https://stackoverflow.com/questions/36341358/how-to-convert-uicolor-to-string-and-string-to-uicolor-using-swift
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
