//
//  Extensions.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 23/04/24.
//

import Foundation

extension String {
    func capitalisedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
