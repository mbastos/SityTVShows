//
//  ComparableExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
