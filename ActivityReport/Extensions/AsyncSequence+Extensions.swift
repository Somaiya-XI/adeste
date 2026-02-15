//
//  AsyncSequence+Extensions.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

import Foundation

extension AsyncSequence where Failure == Never {
    func collect() async -> [Element] {
        // Sending task-isolated 'self' to @concurrent instance method 'reduce(into:_:)' risks causing data races between @concurrent and task-isolated uses
        // try await reduce(into: [Element]()) { $0.append($1) }
        var elements: [Element] = []
        for await element in self {
            elements.append(element)
        }
        return elements
    }
}
