//
//  SideMenuItem.swift
//  ExTimer
//
//  Created by Narender Kumar on 15/07/22.
//

import Foundation
import UIKit

protocol MenuItem_Protocool  {
    var description: String { get }
    var iconImage: UIImage { get }
}

enum SideMenuItem : Int, MenuItem_Protocool {
    case Home = 0
    case About = 1
    case Terms = 2
    case Privacy = 3
    
    var description: String {
        switch self {
        case .Home:
            return "Home"
        case .About:
            return "About Us"
        case .Terms:
            return "Terms and Conditions"
        case .Privacy:
            return "Privacy Policy"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .Home:
            return UIImage(named: "home")!
        case .About:
            return UIImage(named: "home")!
        case .Terms:
            return UIImage(named: "home")!
        case .Privacy:
            return UIImage(named: "home")!
        }
    }
    
}
