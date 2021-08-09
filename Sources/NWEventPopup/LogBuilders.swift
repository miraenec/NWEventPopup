//
//  LogBuilders.swift
//  NWEventPopupFramework
//
//  Created by nextweb on 2018. 1. 3..
//  Copyright © 2018년 nextweb. All rights reserved.
//

import Foundation

@objc
public class LogBuilders : NSObject {
    
    public func build(_ bindMap:Dictionary<String, String>) -> String {
        
        var components = URLComponents()
        print(components.url!)
        components.queryItems = bindMap.map {
            URLQueryItem(name: $0, value: $1)
        }
       return (components.url?.absoluteString)!
    }
}
