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
    var id: String
    var title: String
    //SF Symbols to represent the intention
    var icon: String
    var apps: [String]?
    var focus: Double = 0.0
    var distraction: Double = 0.0
    
    public init(title: String, icon: String = "plus", focus: Double = 0.0, distraction: Double = 0.0) {
        self.id = UUID().uuidString
        self.title = title
        self.icon = icon
        self.focus = focus
        self.distraction = distraction
        self.apps = nil
    }
    
    
    func registerFocus() {
        self.focus += 1.0
    }
    
    func registerDistraction() {
        self.distraction += 1.0
    }

    func editApps(for intention: inout Intention, with apps: [String]) {
        
    }
}
