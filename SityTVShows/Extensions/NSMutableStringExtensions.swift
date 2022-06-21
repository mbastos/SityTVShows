//
//  NSMutableStringExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

extension NSMutableAttributedString {
    func replaceFonts(with font: UIFont) {
        let baseFontDescriptor = font.fontDescriptor
        var changes = [NSRange: UIFont]()
        enumerateAttribute(.font, in: NSMakeRange(0, length), options: []) { foundFont, range, _ in
            if let htmlTraits = (foundFont as? UIFont)?.fontDescriptor.symbolicTraits,
                let adjustedDescriptor = baseFontDescriptor.withSymbolicTraits(htmlTraits) {
                let newFont = UIFont(descriptor: adjustedDescriptor, size: font.pointSize)
                changes[range] = newFont
            }
        }
        changes.forEach { range, newFont in
            removeAttribute(.font, range: range)
            addAttribute(.font, value: newFont, range: range)
        }
    }
    
    func trimmingCharacters(in characterSet: CharacterSet) -> NSAttributedString {
        let invertedSet = characterSet.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}
