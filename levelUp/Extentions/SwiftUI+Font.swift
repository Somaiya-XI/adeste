//
//  SwiftUI+Font.swift
//  levelUp
//
//  Created by Somaiya on 28/05/1447 AH.
//

import SwiftUI

extension Font {

    static var s48Heavy: Font {
        .system(size: 48, weight: .heavy, design: .rounded)
    }

    static var s32Bold: Font {
        .system(size: 32, weight: .bold, design: .rounded)
    }

    static var s32Medium: Font {
        .system(size: 32, weight: .medium, design: .rounded)
    }

    static var s28Medium: Font {
        .system(size: 28, weight: .medium, design: .rounded)
    }

    static var s24Medium: Font {
        .system(size: 24, weight: .medium, design: .rounded)
    }

    static var s24Semibold: Font {
        .system(size: 24, weight: .semibold, design: .rounded)
    }
    
    static var s24Light: Font {
        .system(size: 24, weight: .light, design: .rounded)
    }

    static var s20Medium: Font {
        .system(size: 20, weight: .medium, design: .rounded)
    }

    static var s20Semibold: Font {
        .system(size: 20, weight: .semibold, design: .rounded)
    }

    static var s18Medium: Font {
        .system(size: 18, weight: .medium, design: .rounded)
    }
    
    static var s18Semibold: Font {
        .system(size: 18, weight: .semibold, design: .rounded)
    }

    static var s16Medium: Font {
        .system(size: 16, weight: .medium, design: .rounded)
    }

    static var s16Semibold: Font {
        .system(size: 16, weight: .semibold, design: .rounded)
    }

    static var s16Regular: Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }

    static var s14Medium: Font {
        .system(size: 14, weight: .medium, design: .rounded)
    }

    static var s12Medium: Font {
        .system(size: 12, weight: .medium, design: .rounded)
    }

    static var s12Light: Font {
        .system(size: 12, weight: .light, design: .rounded)
    }

    static var s10Medium: Font {
        .system(size: 10, weight: .medium, design: .rounded)
    }

    /// Large decoration icon (e.g. habit card). 80pt.
    static var s80Regular: Font {
        .system(size: 80, weight: .regular, design: .rounded)
    }
}

// MARK: - View extension for applying dynamic types

extension View {
    @ViewBuilder func DynamicFont(name: String = UIFont.systemFont(ofSize: 0).familyName, size: CGFloat, weight: Font.Weight = .regular, relativeTo: Font.TextStyle, design: Font.Design = .rounded) -> some View {
        self
            .font(.custom(name, size: size, relativeTo: relativeTo))
            .fontWeight(weight)
            .fontDesign(design)
    }
}


extension View {
    func s48Heavy() -> some View {
        self.DynamicFont(size: 48, weight: .heavy, relativeTo: .largeTitle)
    }
}

extension View {
    func font48Heavy() -> some View {
        self.DynamicFont(size: 48, weight: .heavy, relativeTo: .largeTitle)
    }
    
    func font32Bold() -> some View {
        self.DynamicFont(size: 32, weight: .bold, relativeTo: .title)
    }
    
    func font32Medium() -> some View {
        self.DynamicFont(size: 32, weight: .medium, relativeTo: .title)
    }
    
    func font28Medium() -> some View {
        self.DynamicFont(size: 28, weight: .medium, relativeTo: .title2)
    }
    
    func font24Medium() -> some View {
        self.DynamicFont(size: 24, weight: .medium, relativeTo: .title3)
    }
    
    func font24Semibold() -> some View {
        self.DynamicFont(size: 24, weight: .semibold, relativeTo: .title3)
    }
    
    func font24Light() -> some View {
        self.DynamicFont(size: 24, weight: .light, relativeTo: .title3)
    }
    
    func font20Medium() -> some View {
        self.DynamicFont(size: 20, weight: .medium, relativeTo: .headline)
    }
    
    func font20Semibold() -> some View {
        self.DynamicFont(size: 20, weight: .semibold, relativeTo: .headline)
    }
    
    func font18Medium() -> some View {
        self.DynamicFont(size: 18, weight: .medium, relativeTo: .body)
    }
    
    func font18Semibold() -> some View {
        self.DynamicFont(size: 18, weight: .semibold, relativeTo: .body)
    }
    
    func font16Medium() -> some View {
        self.DynamicFont(size: 16, weight: .medium, relativeTo: .callout)
    }
    
    func font16Semibold() -> some View {
        self.DynamicFont(size: 16, weight: .semibold, relativeTo: .callout)
    }
    
    func font16Regular() -> some View {
        self.DynamicFont(size: 16, weight: .regular, relativeTo: .callout)
    }
    
    func font14Medium() -> some View {
        self.DynamicFont(size: 14, weight: .medium, relativeTo: .subheadline)
    }
    
    func font12Medium() -> some View {
        self.DynamicFont(size: 12, weight: .medium, relativeTo: .footnote)
    }
    
    func font12Light() -> some View {
        self.DynamicFont(size: 12, weight: .light, relativeTo: .footnote)
    }
    
    func font10Medium() -> some View {
        self.DynamicFont(size: 10, weight: .medium, relativeTo: .caption2)
    }
    
    /// Large decoration icon (e.g. habit card). 80pt.
    func font80Regular() -> some View {
        self.DynamicFont(size: 80, weight: .regular, relativeTo: .largeTitle)
    }
}
