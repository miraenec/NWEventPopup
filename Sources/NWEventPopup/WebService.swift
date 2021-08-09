//
//  WebService.swift
//  NWEventPopup
//
//  Created by MorrisKim on 2020/04/05.
//  Copyright © 2020 Nextweb Co., Ltd. All rights reserved.
//

import Foundation
import AFNetworking

class WebService {
    
    public class func requestGetUrl(strURL: String, parameters: Any, success: @escaping(URLSessionDataTask?, Any?) -> (), failure: @escaping(URLSessionDataTask?, Error?) -> ()) {
     
        let manager = AFHTTPSessionManager(baseURL: URL(string: AppConstants.getPopupUrl)!)
        manager.get(strURL, parameters: nil, headers: nil, progress: nil, success: { (task, response) in
            
            success(task, response)
            
        }, failure: { (task, error) in
            
            failure(task, error)
        })
    }
    
}
