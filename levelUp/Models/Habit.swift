//
//  Habit.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData
import Adhan


@Model
class Habit: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var isEnabled: Bool = true
    var typeRawValue: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isEnabled
        case typeRawValue
    }
    
    // MARK: - Codable Conformance

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        self.typeRawValue = try container.decode(String.self, forKey: .typeRawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(typeRawValue, forKey: .typeRawValue)
    }
    
    init(id: String, title: String, type: HabitType, isEnabled: Bool)  {
        self.id = id
        self.title = title
        self.typeRawValue = type.rawValue
        self.isEnabled = isEnabled
    }
}



enum HabitType: String, Codable {
    case water
    case steps
    case wakeUp
    case prayer
    case athkar

    
}



// General Structure for Habit Managements
protocol HabitManager  {
    var id: String { get set }
    var name: String { get set }
    func calculateHabitProgress()
}


extension Habit {
    convenience init(title: String, type: HabitType) {
        self.init(
            id: UUID().uuidString,
            title: title,
            type: type,
            isEnabled: true
        )
    }
}
extension Habit {
    var type: HabitType {
        HabitType(rawValue: typeRawValue) ?? .water
    }
}


