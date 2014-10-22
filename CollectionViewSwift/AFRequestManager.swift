//
//  AFRequestManager.swift
//  CollectionViewSwift
//
//  Created by jins on 14-10-22.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import UIKit

let requestManager = AFRequestManager()

class AFRequestManager {
    // Singleton
    class func sharedManager() -> AFRequestManager {
        return requestManager
    }
    
    
    func requestWithUrl(urlString: String, completion: (result: NSData) -> Void) {
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if error != nil {
                println(error)
            } else {
                completion(result: data)
            }
        }
        task.resume()
    }
}
