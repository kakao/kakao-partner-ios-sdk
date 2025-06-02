

//  Copyright 2025 Kakao Corp.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
 

import Foundation
@_exported import KakaoSDKFriendCore

extension KFPaths {
    static let chatMembers = "/v1/api/talk/members"
}

extension PickerApi {
    /// 임베드 형태의 싱글 피커 요청
    public func singleFriendPickerView(
        params: PickerFriendRequestParams,
        targetInfo: TargetInfo,
        selectedFavoriteUuids: [String]? = nil,
        customSection: CustomSection? = nil,
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        PickerApi.shared.____spv(params: params, customSection: customSection, selectedUuids: selectedFavoriteUuids) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    ///  chatId로 임베드용 싱글 채팅방 멤버 피커 요청
    public func singleChatMemberPickerView(
        params: PickerChatMemberRequestParams,
        targetInfo: TargetInfo,
        chatId: Int64,
        friendsOnly: Bool? = nil,
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        PickerApi.shared.____smv(params: params.toFriendRequestParams(), chatId: chatId, friendsOnly: friendsOnly) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    /// 임베드 형태의 멀티 피커 요청
    public func multiFriendPickerView(
        params: PickerFriendRequestParams,
        targetInfo: TargetInfo,
        selectedUuids: [String]? = nil,
        customSection: CustomSection? = nil,
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        PickerApi.shared.____mpv(params: params, customSection: customSection, selectedUuids: selectedUuids) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    /// chatId로 임베드용 멀티 채팅방 멤버 피커 요청 \
    /// Request an embedded multi-chatroom member picker using a chatId.
    public func multiChatMemberPickerView(
        params: PickerChatMemberRequestParams,
        targetInfo: TargetInfo,
        chatId: Int64,
        selectedUuids: [String]? = nil,
        friendsOnly: Bool? = nil,
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        PickerApi.shared.____mmv(params: params.toFriendRequestParams(), chatId: chatId, friendsOnly: friendsOnly, selectedUuids: selectedUuids) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    /// 채팅방 멤버 가져오기
    public func chatMembers(chatId:Int64,
                            targetInfo: TargetInfo,
                            friendsOnly: Bool? = nil,
                            includeProfile: Bool? = nil,
                            token: String? = nil,
                            completion:@escaping (ChatMembers?, Error?) -> Void) {
        setup(targetInfo: targetInfo)
        let parameters = makeParameters(parameters: [
            "chat_id": chatId,
            "friends_only": friendsOnly,
            "include_profile": includeProfile,
            "token": token
        ])
        
        CF.responseData(.get,
                        KFUrls.compose(path: KFPaths.chatMembers),
                        parameters: parameters) { [weak self] (response, data, error) in
            if let error {
                completion(nil, self?.castSdkError(responseInfo: ResponseInfo(response, data), error: error))
                return
            }
            
            if let data {
                completion(try? KFJSONDecoder.custom.decode(ChatMembers.self, from: data), nil)
                return
            }
            
            completion(nil, KFSdkError())
        }
    }
    

    /// uuid로 임베드용 싱글 친구 피커 요청, 친구인 uuid 대상만 표시됨 \
    /// Request an embedded single friend picker using a uuid. Displayed only for uuid targets that are friends.
    public func singleChatMemberPickerViewByUuids(
        params: PickerChatMemberRequestParams,
        targetInfo: TargetInfo,
        uuids: [String],
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        PickerApi.shared.____fspv(params: params.toFriendRequestParams(), uuids: uuids) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    /// uuid로 임베드용 멀티 친구 피커를 요청, 친구인 uuid 대상만 표시됨 \
    /// Request an embedded multi-friend picker using a uuid. Displayed only for uuid targets that are friends.
    public func multiChatMemberPickerViewByUuids(
        params: PickerChatMemberRequestParams,
        targetInfo: TargetInfo,
        uuids: [String],
        selectedUuids: [String]? = nil,
        completion: @escaping (PickerView?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        PickerApi.shared.____fmpv(params: params.toFriendRequestParams(), uuids: uuids, selectedUuids: selectedUuids) { [weak self] pickerView, responseInfo, error in
            completion(pickerView, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
}

// MARK: - Friend Picker
extension PickerApi {
    /// 풀 스크린 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in full-screen view
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriends(
        params: PickerFriendRequestParams,
        targetInfo: TargetInfo,
        selectedUuids: [String]? = nil,
        customSection: CustomSection? = nil,
        completion:@escaping (SelectedUsers?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        
        ____sfs(params: params, needScopeRequest: false, customSection: customSection, selectedUuids: selectedUuids) { [weak self] users, responseInfo, error in
            completion(users, self?.castSdkError(responseInfo: responseInfo, error: error))
        }
    }
    
    /// 팝업 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in pop-up view
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendsPopup(
        params:PickerFriendRequestParams,
        targetInfo: TargetInfo,
        selectedUuids: [String]? = nil,
        customSection: CustomSection? = nil,
        completion:@escaping (SelectedUsers?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____sfsp(params: params, needScopeRequest: false, customSection: customSection, selectedUuids: selectedUuids) { [weak self] selectedUsers, responseInfo, error in
            completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 풀 스크린 형태의 싱글 피커 요청 \
    /// Requests a single picker in full-screen view
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriend(
        params:PickerFriendRequestParams,
        targetInfo: TargetInfo,
        completion:@escaping (SelectedUsers?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____sf(params: params, needScopeRequest: false) { [weak self] selectedUsers, responseInfo, error in
            completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 팝업 형태의 싱글 피커 요청 \
    /// Requests a single picker in pop-up view
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendPopup(params:PickerFriendRequestParams, targetInfo: TargetInfo, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        setup(targetInfo: targetInfo)
        ____sfp(params: params, needScopeRequest: false) { [weak self] selectedUsers, responseInfo, error in
            completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 풀 스크린 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in full-screen view
    /// ## SeeAlso
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChat(
        params:PickerChatRequestParams,
        targetInfo: TargetInfo,
        completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____sc(params: params, needScopeRequest: false) { [weak self] selectedUsers, selectedChat, responseInfo, error in
            completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 팝업 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in pop-up view
    /// ## SeeAlso
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChatPopup(
        params:PickerChatRequestParams,
        targetInfo: TargetInfo,
        completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____scp(params: params, needScopeRequest: false) { [weak self] selectedUsers, selectedChat, responseInfo, error in
            completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 풀 스크린 형태의 탭 피커 요청 \
    /// Requests a tap picker in full-screen view
    /// ## SeeAlso
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func select(
        params:PickerTabRequestParams,
        targetInfo: TargetInfo,
        completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____s(params: params, needScopeRequest: false) { [weak self] selectedUsers, selectedChat, responseInfo, error in
            completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
    
    /// 팝업 형태의 탭 피커 요청 \
    /// Requests a tap picker in pop-up view
    /// ## SeeAlso
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectPopup(
        params:PickerTabRequestParams,
        targetInfo: TargetInfo,
        completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void
    ) {
        setup(targetInfo: targetInfo)
        ____sp(params: params, needScopeRequest: false) { [weak self] selectedUsers, selectedChat, responseInfo, error in
            completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
        }
    }
}

extension PickerApi {
    private func setup(targetInfo: TargetInfo) {
        updateSharingData(SharingData(kapiHost: ConfigInfo.shared.kapiHost, kaHeader: targetInfo.targetKaHeader, appKey: targetInfo.appKey))
        updateAuth(accessToken: targetInfo.accessToken)
    }
    
    private func castSdkError(responseInfo:ResponseInfo?, error:Error?) -> Error? {
        if let kfSdkError = error as? KFSdkError {
            return kfSdkError
        }
        
        if let responseInfo = responseInfo, let data = responseInfo.data, let response = responseInfo.response {            
            if let apiSdkError = KFApiSdkError(response: response, data: data) {
                return apiSdkError
            }
        }
        
        return error
    }
    
    private func makeParameters(parameters: [String: Any?]) -> [String: Any]? {
        let result = parameters.filter({ $0.value != nil }).mapValues({ $0! })
        return result.isEmpty ? nil : result
    }
}
