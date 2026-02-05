//
//  SwiftUI+Font.swift
//  levelUp
//
//  Created by Somaiya on 28/05/1447 AH.
//

import SwiftUI

extension Font {
    static func PlaypenSans(size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
        Font.custom("Playpen Sans Arabic", size: size, relativeTo: textStyle)
    }
    
    static var playpenLargeTitle: Font {
        Font.custom("Playpen Sans Arabic", size: 34, relativeTo: .largeTitle)
    }
    
    static var playpenTitle: Font {
        Font.custom("Playpen Sans Arabic", size: 28, relativeTo: .title)
    }
    
    static var playpenTitle2: Font {
        Font.custom("Playpen Sans Arabic", size: 24, relativeTo: .title2)
    }
    
    static var playpenTitle3: Font {
        Font.custom("Playpen Sans Arabic", size: 22, relativeTo: .title2)
    }
    
    static var playpenTitle4: Font {
        Font.custom("Playpen Sans Arabic", size: 22, relativeTo: .title3)
    }
    
    static var playpenBody: Font {
        Font.custom("Playpen Sans Arabic", size: 20, relativeTo: .body)
    }
    
    static var playpenCallout: Font {
        Font.custom("Playpen Sans Arabic", size: 17, relativeTo: .callout)
    }
    
    static var playpenSubhead: Font {
        Font.custom("Playpen Sans Arabic", size: 16, relativeTo: .subheadline)
    }
    
    static var playpenFootnote: Font {
        Font.custom("Playpen Sans Arabic", size: 14, relativeTo: .footnote)
    }
    
    static var playpenCaption: Font {
        Font.custom("Playpen Sans Arabic", size: 13, relativeTo: .caption)
    }
    
    static var playpenCaption2: Font {
        Font.custom("Playpen Sans Arabic", size: 12, relativeTo: .caption2)
    }
    
}





