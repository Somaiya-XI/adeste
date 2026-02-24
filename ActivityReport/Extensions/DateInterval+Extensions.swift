//
//  DateInterval.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

import Foundation

extension DateInterval {
    var stringRepresentation: String {
        let start = self.start.formatted(date: .abbreviated, time: .shortened)
        let end = self.end.formatted(date: .abbreviated, time: .shortened)
        return "\(start) ~\n\(end)"
    }
}
