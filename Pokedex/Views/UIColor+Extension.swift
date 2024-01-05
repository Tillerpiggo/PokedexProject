//
//  UIColor+Extension.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import UIKit

extension UIColor {
    
    // Helper function to create a dynamic color based on the user interface style
    private static func dynamicColor(light: (CGFloat, CGFloat, CGFloat), dark: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        UIColor { traitCollection in
            let (r, g, b) = traitCollection.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
        }
    }
    
    static let statLabelTextColor: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.black.withAlphaComponent(0.9)
        default:
            return UIColor.white.withAlphaComponent(1.0)
        }
    }
    
    // Updated stat bar colors with fainter light versions
    static let hpColor = dynamicColor(
        light: (210, 47, 47),
        dark: (235, 98, 98)
    )
    static let hpBackgroundColor = dynamicColor(
        light: (245, 180, 180),
        dark: (90, 45, 45)
    )
    
    static let attackColor = dynamicColor(
        light: (230, 126, 34),
        dark: (250, 166, 74)
    )
    static let attackBackgroundColor = dynamicColor(
        light: (250, 210, 160),
        dark: (108, 72, 34)
    )
    
    static let defenseColor = dynamicColor(
        light: (245, 199, 0),
        dark: (255, 219, 77)
    )
    static let defenseBackgroundColor = dynamicColor(
        light: (255, 239, 180),
        dark: (128, 102, 0)
    )
    
    static let specialAttackColor = dynamicColor(
        light: (39, 174, 96),
        dark: (89, 224, 146)
    )
    static let specialAttackBackgroundColor = dynamicColor(
        light: (198, 248, 230),
        dark: (63, 128, 107)
    )
    
    static let specialDefenseColor = dynamicColor(
        light: (41, 128, 185),
        dark: (71, 168, 235)
    )
    static let specialDefenseBackgroundColor = dynamicColor(
        light: (158, 235, 252),
        dark: (58, 108, 117)
    )
    
    static let speedColor = dynamicColor(
        light: (142, 68, 173),
        dark: (162, 88, 193)
    )
    static let speedBackgroundColor = dynamicColor(
        light: (220, 190, 255),
        dark: (90, 72, 92)
    )
}

extension UIColor {
    static let normalBeige = dynamicColor(
        light: (168, 167, 122),
        dark: (128, 127, 82)
    )
    static let fireRed = dynamicColor(
        light: (237, 109, 18),
        dark: (187, 59, 0)
    )
    static let waterBlue = dynamicColor(
        light: (99, 144, 240),
        dark: (49, 94, 190)
    )
    static let electricYellow = dynamicColor(
        light: (247, 208, 44),
        dark: (197, 158, 0)
    )
    static let grassGreen = dynamicColor(
        light: (122, 199, 76),
        dark: (72, 149, 26)
    )
    static let iceBlue = dynamicColor(
        light: (150, 217, 214),
        dark: (100, 167, 164)
    )
    static let fightingOrange = dynamicColor(
        light: (194, 46, 40),
        dark: (144, 0, 0)
    )
    static let poisonPurple = dynamicColor(
        light: (163, 62, 161),
        dark: (113, 12, 111)
    )
    static let groundBrown = dynamicColor(
        light: (226, 191, 101),
        dark: (176, 141, 51)
    )
    static let flyingLavender = dynamicColor(
        light: (169, 143, 243),
        dark: (119, 93, 193)
    )
    static let psychicPink = dynamicColor(
        light: (249, 85, 135),
        dark: (199, 35, 85)
    )
    static let bugGreen = dynamicColor(
        light: (166, 185, 26),
        dark: (116, 135, 0)
    )
    static let rockGray = dynamicColor(
        light: (182, 161, 54),
        dark: (132, 111, 4)
    )
    static let ghostPurple = dynamicColor(
        light: (111, 88, 152),
        dark: (61, 38, 102)
    )
    static let dragonBlue = dynamicColor(
        light: (111, 53, 252),
        dark: (61, 3, 202)
    )
    static let darkBlack = dynamicColor(
        light: (112, 87, 70),
        dark: (62, 37, 20)
    )
    static let steelGray = dynamicColor(
        light: (183, 183, 206),
        dark: (133, 133, 156)
    )
    static let fairyPink = dynamicColor(
        light: (214, 133, 173),
        dark: (164, 83, 123)
    )
}

extension UIColor {
    static let normalTitle = dynamicColor(
        light: (155, 154, 124),
        dark: (168, 167, 122)
    )
    static let fireTitle = dynamicColor(
        light: (228, 120, 50),
        dark: (237, 109, 18)
    )
    static let waterTitle = dynamicColor(
        light: (50, 124, 220),
        dark: (99, 144, 240)
    )
    static let electricTitle = dynamicColor(
        light: (227, 188, 30),
        dark: (247, 208, 44)
    )
    static let grassTitle = dynamicColor(
        light: (142, 219, 106),
        dark: (122, 199, 76)
    )
    static let iceTitle = dynamicColor(
        light: (125, 222, 219),
        dark: (150, 217, 214)
    )
    static let fightingTitle = dynamicColor(
        light: (194, 50, 50),
        dark: (194, 46, 40)
    )
    static let poisonTitle = dynamicColor(
        light: (173, 82, 181),
        dark: (163, 62, 161)
    )
    static let groundTitle = dynamicColor(
        light: (206, 171, 81),
        dark: (226, 191, 101)
    )
    static let flyingTitle = dynamicColor(
        light: (169, 143, 243),
        dark: (169, 143, 243)
    )
    static let psychicTitle = dynamicColor(
        light: (249, 85, 135),
        dark: (249, 85, 135)
    )
    static let bugTitle = dynamicColor(
        light: (166, 185, 26),
        dark: (166, 185, 26)
    )
    static let rockTitle = dynamicColor(
        light: (182, 161, 54),
        dark: (182, 161, 54)
    )
    static let ghostTitle = dynamicColor(
        light: (111, 88, 152),
        dark: (111, 88, 152)
    )
    static let dragonTitle = dynamicColor(
        light: (111, 53, 252),
        dark: (111, 53, 252)
    )
    static let darkTitle = dynamicColor(
        light: (112, 87, 70),
        dark: (112, 87, 70)
    )
    static let steelTitle = dynamicColor(
        light: (183, 183, 206),
        dark: (183, 183, 206)
    )
    static let fairyTitle = dynamicColor(
        light: (214, 133, 173),
        dark: (214, 133, 173)
    )
}
