//
//  Constants.swift
//  adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

/**
 This file contains the collection of constant strings of the app to be used on views
 this approach helps keeping content in sync and makes future modification easier
 **/

import Foundation

struct consts {
    
    static let fajrStr = "FJR"
    static let dhuhrStr = "DHR"
    static let asrStr = "ASR"
    static let magribStr = "MGB"
    static let ishaStr = "ISH"
    
    //Icon Strings
    static let homeActiveTabIconStr = "house.fill"
    
    static let intentionsActiveTabIconStr = "sparkle.text.clipboard.fill"
    
    static let profileActiveTabIconStr = "person.fill"
    
    
    // Pages Titles
    static let homepageStr = "Home"
    static let intentionpageStr = "Intention"
    static let profilepageStr = "Profile"
    
    // Tab Icons
    static let homeTabIconStr = "house.fill"
    static let intentionsTabIconStr = "sparkle.text.clipboard.fill"
    static let profileTabIconStr = "person.fill"
    
    // Intentions View
    static let weeklySummaryStr = "Intention summary"
    static let currentIntentionStr = "Current intention"
    static let startIntentionStr = "Pick your intention"
    static let newIntentionStr = "New Intention"
    static let editIntentionStr = "Edit Intention"
    static let managedAppsStr = "Managed Apps"
    static let focusedStr = "Focused"
    
    static let newIntentionNameStr = "Name your intention"
    
    // Profile & Achievements
    static let achievementsStr = "Achievements"
    static let settingsStr = "Settings"
    static let selectCycleStr = "Select New Cycle"
    static let manageIntentionsStr = "Manage Intentions"
    static let manageAccountStr = "Manage Account"
    
    // Actions
    static let addMoreStr = "Add more"
    static let cancelStr = "Cancel"
    static let saveStr = "Save"
    static let deleteIntentionStr = "Delete Intention"
    static let stopStr = "Stop"
    
    // Icons (System Symbols & Assets)
    // Assets
    static let chevronRight = "ic_chevron"
    static let chevronBack = "ic_back"
    static let checkmarkIcon = "checkmark"
    static let editIcon = "pencil.and.outline"
    static let plusIcon = "plus"
    static let emptyWaterbottleIconStr = "waterbottle"
    static let fullWaterbottleIconStr = "waterbottle.fill"
    static let stopTimerIconStr = "clock.badge.xmark"
    
    static let emptyIntentionChartIconStr = "chart.bar.xaxis.ascending.badge.clock" //"chart.line.text.clipboard"

    static let emptyIntentionSummaryStr = "Track an intention to unlock your summary"
 
    
    //alerts
    static let WaterAlertTitleStr = "Slow Down!"
    static let WaterAlertMessageStr = "Drinking too much at once isn't healthy. You can add more in 90 minutes."
    
    static let WakeUpAlertTitleStr = "Better Luck Tomorrow"
    static let WakeUpAlertMessageStr = "Remember to check in within 30 minutes of waking up!"
    
    static let IntentionAlertMessageStr = "If you stop now, this session won't be added to your summary."
    
}
