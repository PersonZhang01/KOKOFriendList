//
//  APIComposition.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Alamofire

protocol APIRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String : Any] { get }
}

extension APIRequest {
    
    func getHeader() -> HTTPHeaders {
        var result: [String: String] = [:]
        return HTTPHeaders(result)
    }
    
    func getUrlString() -> String {
        return "\(APIManager.host)\(path)"
    }
}

struct ApiResp<T: Codable>: Codable {
    var success: Bool?
    var msg: String?
    var value: T?
}

struct ApiURL {
    static let userInfo = "man.json"                   // 取得使用者資料
    static let friendList = ["friend1.json",
                             "friend2.json",
                             "friend3.json",
                             "friend4.json"]           // 取得好友列表
}

