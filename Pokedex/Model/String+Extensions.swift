//
//  String+Extensions.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/23/23.
//

import Foundation

extension String {
    func parseFlavorText() -> String {
        // Replace soft hyphen followed by a newline character with an empty string
        let withoutSoftHyphen = self.replacingOccurrences(of: "­\n", with: "")
        
        // Replace form feed and other control characters with a space
        let withoutControlCharacters = withoutSoftHyphen
            .replacingOccurrences(of: "\u{000c}", with: " ")
            .replacingOccurrences(of: "\\n", with: " ")
            .replacingOccurrences(of: "\\r", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
        
        // Remove additional spaces that may have been created by the replacements above
        let squashedSpaces = withoutControlCharacters
            .split(separator: " ")
            .joined(separator: " ")
        
        return squashedSpaces
    }
    
    func parsingHyphens() -> String {
        // Split the version name by hyphens and join them using a space
        let components = self.split(separator: "-").map(String.init)
        let joinedComponents = components.joined(separator: " ")

        // Capitalize the first letter of each word
        let capitalizedVersionName = joinedComponents
            .split(separator: " ")
            .map { $0.prefix(1).capitalized + $0.dropFirst().lowercased() }
            .joined(separator: " ")

        return capitalizedVersionName
    }
}
