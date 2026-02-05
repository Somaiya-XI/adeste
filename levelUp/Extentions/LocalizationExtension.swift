//
//  LocalizationExtension.swift
//  levelUp
//
//  Created by Jory on 10/06/1447 AH.
//


import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
