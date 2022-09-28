//
//  Constants.swift
//  Ios_create_goal_based_savings_fma
//
//  Created by pawan kumar on 08/06/22
//  
//

import Foundation
import UIKit

class Constants {
    static let sdkBundle = Bundle(for: Constants.self)

    static let cornerRadiusButton: CGFloat = 30.0
    static let cornerRadiusView8: CGFloat = 8.0
    static let cornerRadiusView12: CGFloat = 12.0
    static let cornerRadiusView15: CGFloat = 15.0
    static let cornerRadiusView4: CGFloat = 4.0

    static let nameCharacterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    static let numberCharacterSet = "0123456789"
    static let alphaNumericCharacterSet = Constants.numberCharacterSet + Constants.nameCharacterSet
    
    static let effectCellIdentifier = "effectCell"
    
    static let cards : [Card] = [
        Card(imageBg: "card1", titleText: "Realistic cartoon", descText: "Cartoonize yourself with different backgrounds!"),
        Card(imageBg: "card2", titleText: "#NewProfilePic", descText: "Refresh your socials with one tap!"),
        Card(imageBg: "card3", titleText: "Style transfer", descText: "Recompose the content of an image in the style."),
        Card(imageBg: "card4", titleText: "Funny caricatures", descText: "Turn yourself into a funny character.")
    ]
}



struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

struct StringLengthConstant {
    static let savingNameMaxLength = 30
    static let amountMaxLength = 10
}

struct FormatterConstant {
    static let defaultDateFormatter = "yyyy-MM-dd HH:mm:ss"
    static let ddMMYYYY = "dd/MM/yyyy"
    static let oneArg = "%@"
    static let oneArgWithColon = ": %@"
    static let oneArgWithColonArbic = "%@ :"
    static let twoArg = "%@ %@"
    static let twoArgWithBracket = "%@ (%@)"
    static let twoArgWithStartColon = ": %@ %@"
    static let twoArgWithStartColonArabic = "%@ %@ :"
    static let twoArgWithBetweenColon = "%@ : %@"
    static let interestRate = "%@ : %@%%"
    static let threeArg = "%@ %@ %@"
    static let threeArgWithColon = "%@ : %@ %@"
}


public enum Effects {
    case realisticCartoon
    case newProfilePic
    case styleTransfer
    case funnyCaricatures
    case none
}

struct InAppProduct {
    static let ONE_WEEK: String = "com.mobirizer.cartoon.oneweek"
    static let ONE_YEAR: String = "com.mobirizer.cartoon.oneyear"
}
