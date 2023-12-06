//
//  UserInfoUseCase.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Combine
import Alamofire

// 使用API的protocol，降低耦合度
protocol UserInfoUseCaseType {
    func userInfo() -> AnyPublisher<DataResponse<UserInfoRespModel,NetworkError>, Never>
}

// 實作API的Class
class UserInfoUseCase: UserInfoUseCaseType {
    func userInfo() -> AnyPublisher<Alamofire.DataResponse<UserInfoRespModel, NetworkError>, Never> {
        return APIManager.shared.fetchResponse(apiReq:UserInfoRequest())

    }
}

