//
//  APIManager.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Combine
import Alamofire

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol APIManagerProtocol {
    func fetchResponse<T:Codable>(apiReq: APIRequest) -> AnyPublisher<DataResponse<T,NetworkError>, Never>
}

class APIManager {
    static let shared: APIManagerProtocol = APIManager()
    
    static let apiHost: String = "https://dimanyen.github.io/"
    static var host: String {
        return apiHost
    }
}

extension APIManager: APIManagerProtocol {
    
    
    func fetchResponse<T>(apiReq: APIRequest) -> AnyPublisher<Alamofire.DataResponse<T, NetworkError>, Never> where T : Decodable, T : Encodable {
        debugPrint("ApiReq:\(apiReq.getUrlString())")
        
        return AF.request(apiReq.getUrlString(),
                          method: apiReq.method,
                          parameters: apiReq.parameters,
                          encoding: (apiReq.method == .post) ? JSONEncoding.default : URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets),
                          headers: apiReq.getHeader())
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap{ try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

