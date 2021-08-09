//
//  StringUtil.swift
//  NWAppLogFramework
//
//  Created by nextweb on 2018. 1. 3..
//  Copyright © 2018년 nextweb. All rights reserved.
//

import Foundation

@objc
class StringUtil: NSObject {
    static func nilChecker(_ p:String) -> String {
        if !p.isEmpty {
            return p
        } else {
            return ""
        }
    }
    
    static func queryDictionary(_ str:String) -> Dictionary<String, AnyObject> {
        var dictionary:Dictionary<String, AnyObject> = [:]
        
        if let query:String = str as String? {
            dictionary = Dictionary<String, AnyObject>()
            
            for keyValueString in query.components(separatedBy: "&") {
                let parts = keyValueString.components(separatedBy: "=")
                if parts.count < 2 { continue; }
                
                let key = (parts[0] as AnyObject).removingPercentEncoding!
                let value = (parts[1] as AnyObject).removingPercentEncoding!
                
                dictionary[key!] = value as AnyObject
            }
        }
        
        return dictionary
    }
    
    static func encodeAsUtf8(_ str:String) -> String {
        let encodedStr = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        return encodedStr!
    }
    
    static func encodeAsUtf8(_ bindMap:Dictionary<String, Any>) -> Dictionary<String, Any> {
        var modifiedBindMap = Dictionary<String, Any>()
        
        for (key, value) in bindMap {
            modifiedBindMap[key] = encodeAsUtf8(String(describing: value)) as Any
        }
        
        return modifiedBindMap
    }
    
    static func convertDictionaryToJson(_ dict:Dictionary<String, AnyObject>) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        return jsonString
    }
    
    static func toDictionary(_ json: AnyObject) -> [String:String] {
        do {
            let jsonData =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Dictionary<String, String> ?? [:]
            
            return jsonDic
        } catch let err {
            print("err:\(err.localizedDescription)")
        }
        
        return [:]
    }
    
    static func URLEncode(_ str:String) -> String {
        //        return CFURLCreateStringByAddingPercentEscapes(nil, str as CFString, nil, "!*'();:@&=+$,/?%#[]\" " as CFString, kCFStringEncodingASCII) as String
        
        return str.addingPercentEncoding(withAllowedCharacters: ("!*'();:@&=+$,/?%#[]\" " as CFString) as! CharacterSet)!
    }
}
