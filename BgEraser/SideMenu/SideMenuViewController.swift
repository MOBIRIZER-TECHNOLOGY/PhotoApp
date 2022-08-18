//
//  SideMenuViewController.swift
//  ExTimer
//
//  Created by Narender Kumar on 07/07/22.
//

import UIKit
import SSCustomSideMenu

class SideMenuViewController: SSSideMenuContainerViewController {
    
    let menuTable = SSMenuTableView()
    
    enum SideMenuWidth: CGFloat {
        case Whole
        case Half
        case Quarter
        case ThreeQuarter
        
        var valuesInFloat: CGFloat {
            switch self {
            case .Whole: return 1.0
            case .Half: return 0.50
            case .Quarter: return 0.75
            case .ThreeQuarter: return 0.25
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSideMenu()
        
        self.view.backgroundColor = .clear
    }
    
    private func configureSideMenu() {
        
        self.menuTable.backgroundColor = .clear
        menuTable.separatorStyle = .none
        menuTable.rowHeight = 60
        menuTable.showsHorizontalScrollIndicator = false
        menuTable.showsVerticalScrollIndicator = false
        
        let menuCellConfig = SSMenuCellConfig()
        
        menuCellConfig.cellStyle = .defaultStyle // .customStyle
        menuCellConfig.leftIconPadding = 20
        menuCellConfig.imageToTitlePadding = 10
        menuCellConfig.imageHeight = 24
        menuCellConfig.imageWidth = 24
        
        menuCellConfig.selectedColor = UIColor(named: "menu_Btn_Color")!
        menuCellConfig.nonSelectedColor = UIColor(named: "play_Btn_Color")!
        
        menuCellConfig.images = [SideMenuItem.Home.iconImage, SideMenuItem.About.iconImage, SideMenuItem.Terms
                                    .iconImage, SideMenuItem.Privacy.iconImage]
        menuCellConfig.titles = [SideMenuItem.Home.description, SideMenuItem.About.description, SideMenuItem.Terms.description, SideMenuItem.Privacy.description]
        
        menuCellConfig.numberOfOptions = 4
        menuTable.config = menuCellConfig
        
        let sideMenuConfig = SSSideMenuConfig()
        sideMenuConfig.animationType = .slideOut // .slideIn, .compress(0.8, 20)
        sideMenuConfig.sideMenuPlacement = .left // .right
        sideMenuConfig.menuWidth = UIScreen.main.bounds.width * SideMenuWidth.Quarter.valuesInFloat
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        let aboutVC = storyboard?.instantiateViewController(withIdentifier: "AboutVC")
        let termsVC = storyboard?.instantiateViewController(withIdentifier: "TermsVC")
        let privacyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyVC")
        
        sideMenuConfig.viewControllers = [ homeVC!, aboutVC!, termsVC!, privacyVC! ]
        sideMenuConfig.menuTable = menuTable
        self.ssMenuConfig = sideMenuConfig
        
        self.sideMenuDelegate = self
    }
    
}

// MARK: -
// MARK: - SSSideMenu Delegate

extension SideMenuViewController: SSSideMenuDelegate {

    func shouldOpenViewController(forMenuOption menuOption: Int) -> Bool {
        /*
        // Perform action for custom options (i.e logout)
        if menuOption == 3 {
            return false
        } else {
            return true
        }
        */
        
        return true
    }
    
}
