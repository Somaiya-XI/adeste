//
//  ProcessedCategoryActivity.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

struct ProcessedCategoryActivity: Identifiable, @unchecked Sendable {
    var id: UUID = UUID()
    
    // The user’s application activity that contributed to this category’s totalActivityDuration.
    var applications: Array<DeviceActivityData.ApplicationActivity>

    // The category of the activity.
    var category: ActivityCategory

    // The user’s total activity for this category.
    var totalActivityDuration: TimeInterval

    // The user’s web domain activity that contributed to this category’s totalActivityDuration.
    var webDomains: Array<DeviceActivityData.WebDomainActivity>

}
