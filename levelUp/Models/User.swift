//
//  User.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation

// it can be a swiftData OR AppStorage
struct User {
    var id: String
    var name: String
    var cycleHistory: [Cycle]
    var streak: Int
}

