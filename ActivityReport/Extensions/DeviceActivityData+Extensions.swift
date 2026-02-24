//
//  DeviceActivityData+Extensions.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings


extension DeviceActivityData.CategoryActivity {
    var processedCategoryActivity: ProcessedCategoryActivity {
        get async {
            return ProcessedCategoryActivity(
                applications: await self.applications.collect(),
                category: self.category,
                totalActivityDuration: self.totalActivityDuration,
                webDomains: await self.webDomains.collect())
        }
    }
}

extension DeviceActivityData.ActivitySegment {
    var processedActivitySegment: ProcessedActivitySegment {
        get async {
            let categories = await withTaskGroup(of: ProcessedCategoryActivity.self) { group in
                for category in await self.categories.collect() {
                    group.addTask {
                        return await category.processedCategoryActivity
                    }
                }
                return await group.collect()
            }

            
            return ProcessedActivitySegment(
                categories: categories,
                dateInterval: self.dateInterval,
                totalActivityDuration: self.totalActivityDuration,
                totalPickupsWithoutApplicationActivity: self.totalPickupsWithoutApplicationActivity
            )
        }
    }
}


extension DeviceActivityData.User {
    var name: String {
        if self.nameComponents?.familyName == nil && self.nameComponents?.givenName == nil  {
            return "(Unknown User)"
        }
        return "\(self.nameComponents?.givenName, default: "")\(self.nameComponents?.familyName == nil || self.nameComponents?.givenName == nil  ? "" : " ")\(self.nameComponents?.familyName, default: "")"
    }
}

extension DeviceActivityData.Device {
    var name: String {
        return switch self.model {
        case .iPhone:
            "iPhone"
        case .iPod:
            "iPod"
        case .iPad:
            "iPad"
        case .mac:
            "Mac"
        @unknown default:
            "(Unknown Device)"
        }
    }
}



extension DeviceActivityData {
    var processedData: ProcessedDeviceActivityData {
        get async {
            let segments = await withTaskGroup(of: ProcessedActivitySegment.self) { group in
                for segment in await self.activitySegments.collect() {
                    group.addTask {
                        return await segment.processedActivitySegment
                    }
                }
                return await group.collect()
            }
            
            return ProcessedDeviceActivityData(
                user: self.user,
                device: self.device,
                activitySegments: segments,
                segmentInterval: self.segmentInterval,
                lastUpdated: self.lastUpdatedDate
            )

        }
    }
}

extension DeviceActivityResults<DeviceActivityData> {
    var processedData: [ProcessedDeviceActivityData] {
        get async {
            
            let data = await withTaskGroup(of: ProcessedDeviceActivityData.self) { group in
                for raw in await self.collect() {
                    group.addTask {
                        return await raw.processedData
                    }
                }
                return await group.collect()
            }


            return data
        }
    }
}
