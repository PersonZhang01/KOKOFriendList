//
//  UserInfo.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Alamofire


struct UserInfoRequest: APIRequest {
    var method = HTTPMethod.get
    var path = ApiURL.userInfo
    var parameters = [String: Any]()
    
    init() {
        
    }

}

//MARK: UserInfoRespModel
struct UserInfoRespModel: Codable {
    var response: [UserInfoItem]?     // 站點列表
}

struct UserInfoItem: Codable, Hashable, Identifiable {
    let id = UUID()
    
    enum CodingKeys: CodingKey {
        case name
        case kokoid
    }
    
    var name: String?                   // 姓名
    var kokoid: String?                 // Koko id
}

