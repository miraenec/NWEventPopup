//
//  AppInfoUtil.swift
//  NWEventPopupFramework
//
//  Created by nextweb on 2018. 1. 3..
//  Copyright © 2016년 nextweb. All rights reserved.
//

import Foundation

extension String {
    func substringWithLastInstanceOf(_ character: Character) -> String? {
        if let rangeOfIndex = rangeOfCharacter(from: CharacterSet(charactersIn: String(character)), options: .backwards) {
            return String(self[..<rangeOfIndex.upperBound]) // Swift4
        }
        return nil
    }
    func substringWithoutLastInstanceOf(_ character: Character) -> String? {
        if let rangeOfIndex = rangeOfCharacter(from: CharacterSet(charactersIn: String(character)), options: .backwards) {
            return String(self[..<rangeOfIndex.lowerBound]) // Swift4
        }
        return nil
    }
    func lastComponent(_ character: Character) -> String? {
        let str = self.components(separatedBy: String(character))
        let count = str.count
        
        if count == 0 {
            return str[0]
        } else if count > 0 {
            return str[count-1]
        }
        
        return nil
    }
}
