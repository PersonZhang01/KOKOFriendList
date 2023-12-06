//
//  FriendListViewModel.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import Combine

// ViewModel pipeline輸入源頭
struct FriendListViewModelInput {
    let idle: PassthroughSubject<Void, Never>
    let userInfo: PassthroughSubject<Void, Never>
    let friendList: PassthroughSubject<Int, Never>
}

// ViewModel pipeline輸出終點
enum FriendListViewModelState {
    case idle
    case userInfoSuccess(UserInfoRespModel?)
    case userInfoError(NetworkError?)
    case friendListSuccess(FriendListRespModel?)
    case friendListError(NetworkError?)
}

extension FriendListViewModelState: Equatable {
    static func == (lhs: FriendListViewModelState, rhs: FriendListViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.userInfoSuccess, .userInfoSuccess): return true
        case (.userInfoError, .userInfoError): return true
        case (.friendListSuccess, .friendListSuccess): return true
        case (.friendListError, .friendListError): return true
        default: return false
        }
    }
}

typealias FriendListViewModelOutput = AnyPublisher<FriendListViewModelState, Never>

// 轉換輸入成輸出的protocol
protocol FriendListViewModelType {
    func transform(input: FriendListViewModelInput) -> FriendListViewModelOutput
}

// 實作轉換內容
class FriendListViewModel: FriendListViewModelType {
    private let friendListUseCase: FriendListUseCaseType
    private let userInfoUseCase: UserInfoUseCaseType
    
    var userInfo: UserInfoItem = UserInfoItem()
    var friendList: [FriendListItem] = []
    var friendAllList: [FriendListItem] = []
    var inviteList: [FriendListItem] = []
    var searchWord: String = ""
    var selectIndexPath: IndexPath = IndexPath()
    
    init(friendListUseCase: FriendListUseCaseType,
         userInfoUseCase: UserInfoUseCaseType){
        self.userInfoUseCase = userInfoUseCase
        self.friendListUseCase = friendListUseCase
        
    }
    
    func transform(input: FriendListViewModelInput) -> FriendListViewModelOutput {
        return Publishers.Merge3(inputIdle(idle: input.idle),
                                inputUserInfo(userInfo: input.userInfo),
                                inputFriendList(friendList: input.friendList))
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    private func inputIdle(idle: PassthroughSubject<Void, Never>) -> FriendListViewModelOutput {
        let initialState: FriendListViewModelOutput = .just(.idle)
        let idleState: FriendListViewModelOutput = idle.map({ .idle }).eraseToAnyPublisher()
        return Publishers.Merge(initialState, idleState).eraseToAnyPublisher()
    }
    
    private func inputUserInfo(userInfo: PassthroughSubject<Void, Never>) -> FriendListViewModelOutput {
        let request: FriendListViewModelOutput = userInfo.flatMapLatest({[unowned self]
            query in
            userInfoUseCase.userInfo()
        })
            .map({ result -> FriendListViewModelState in
                switch result {
                case _ where result.value != nil:
                    return .userInfoSuccess(result.value)
                case _ where result.error != nil: return .userInfoError(result.error)
                default: return .idle
                }
            }).eraseToAnyPublisher()
        return request
    }
    
    private func inputFriendList(friendList: PassthroughSubject<Int, Never>) -> FriendListViewModelOutput {
        let request: FriendListViewModelOutput = friendList.flatMapLatest({[unowned self]
            query in
            friendListUseCase.friendList(with: query)
        })
            .map({ result -> FriendListViewModelState in
                switch result {
                case _ where result.value != nil:
                    return .friendListSuccess(result.value)
                case _ where result.error != nil: return .friendListError(result.error)
                default: return .idle
                }
            }).eraseToAnyPublisher()
        return request
    }
    
}

extension FriendListViewModel {
    func updateUerInfo(withInfo info: UserInfoRespModel?) {
        guard let info = info else { return }
        userInfo = info.response?.first ?? UserInfoItem()
    }
    
    func updateFriendList(withList list: FriendListRespModel?) {
        guard let list = list else { return }
        inviteList = list.response?.filter({$0.status == 2}) ?? []
        friendList = list.response?.filter({$0.status != 2}) ?? []
        friendAllList = friendList
    }
    
    func searchFriend() {
        debugPrint("searchFriend:\(searchWord)")
        if (searchWord.isEmpty) {
            friendList = friendAllList
            return
        }
        friendList.removeAll()
        friendList = friendAllList.reduce(into: [FriendListItem]()) { result, friend in
            guard let name = friend.name else { return }
            if name.contains(self.searchWord) {
                result.append(friend)
            }
        }
    }

}

