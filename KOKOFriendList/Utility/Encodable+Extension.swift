//
//  Encodable+Extension.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation

extension Encodable {
    var getParameters: Dictionary<String,Any> {
        var result : Dictionary<String,Any> = [:]
        do {
            let data = try JSONEncoder().encode(self)
            result = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any> ?? [:]
        } catch {
            print("getParameters 轉換失敗:\(error)")
        }
        
        return result
    }
    
    func getJsonString() {
        do {
            let data = try JSONEncoder().encode(self)
            if let jsonString = String(data: data, encoding: .utf8) {
                debugPrint("response:\(jsonString)")
            }
        } catch {
            print("getJsonString 轉換失敗:\(error)")
        }
    }
}

