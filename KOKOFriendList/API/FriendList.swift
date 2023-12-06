//
//  FriendList.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Alamofire


struct FriendListRequest: APIRequest {
    var method = HTTPMethod.get
    var path = ApiURL.friendList[0]
    var parameters = [String: Any]()
    
    init(testNum: Int = 1) {
        path = ApiURL.friendList[testNum]
    }

}

//MARK: FriendListRespModel
struct FriendListRespModel: Codable {
    var response: [FriendListItem]?     // 站點列表
}

struct FriendListItem: Codable, Hashable, Identifiable {
    let id = UUID()
    
    enum CodingKeys: CodingKey {
        case name
        case status
        case isTop
        case fid
        case updateDate
    }
    
    var name: String?                   // 姓名
    var status: Int?                    // 0:邀請送出, 1:已完成 2:邀請中
    var isTop: String?                  // 是否出現星星
    var fid: String?                    // 好友id
    var updateDate: String?             // 資料更新時間
}

