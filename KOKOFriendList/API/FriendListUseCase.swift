//
//  FriendListUseCase.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Combine
import Alamofire

// 使用API的protocol，降低耦合度
protocol FriendListUseCaseType {
    func friendList(with testNum:Int) -> AnyPublisher<DataResponse<FriendListRespModel,NetworkError>, Never>
}

// 實作API的Class
class FriendListUseCase: FriendListUseCaseType {
    func friendList(with testNum:Int) -> AnyPublisher<Alamofire.DataResponse<FriendListRespModel, NetworkError>, Never> {
        return APIManager.shared.fetchResponse(apiReq:FriendListRequest(testNum: testNum))

    }
}

