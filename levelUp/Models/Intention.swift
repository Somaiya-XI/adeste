//
//  Intention.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

@Model
class Intention: Identifiable {
    var id: UUID
    var title: String
    //SF Symbols to represent the intention
    var icon: String
    var apps: [String]?
    var focus: Int = 0
    var distraction: Int = 0
    
    public init(id: UUID = UUID(), title: String, icon: String = "", focus: Int = 0, distraction: Int = 0) {
        self.id = id
        self.title = title
        self.icon = icon
        self.apps = nil
    }
}
