//
//  TimeInterval.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

import Foundation

extension TimeInterval {
    static var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }

    var formattedDuration: String {
        return TimeInterval.formatter.string(from: self) ?? "\(self.formatted(.number.precision(.fractionLength(2)))) sec"
    }
}
