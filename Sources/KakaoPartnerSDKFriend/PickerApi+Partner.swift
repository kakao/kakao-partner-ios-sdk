//  Copyright 2019 Kakao Corp.
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
import KakaoSDKFriend

/// [피커](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common) API 클래스 \
/// Class for the [picker](https://developers.kakao.com/internal-docs/latest/ko/kakao-social/common) APIs
extension PickerApi  {
    /// 풀 스크린 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in full-screen view
    /// ## SeeAlso
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriends(params:PickerFriendRequestParams, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, error)
            }
            else {
                self?.____sfs(params: params) { [weak self] selectedUsers, responseInfo, error in
                    completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 팝업 형태의 멀티 피커 요청 \
    /// Requests a multi-picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendsPopup(params:PickerFriendRequestParams, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, error)
            }
            else {
                self?.____sfsp(params: params) { [weak self] selectedUsers, responseInfo, error in
                    completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 풀 스크린 형태의 싱글 피커 요청 \
    /// Requests a single picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriend(params:PickerFriendRequestParams, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, error)
            }
            else {
                self?.____sf(params: params) { [weak self] selectedUsers, responseInfo, error in
                    completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 팝업 형태의 싱글 피커 요청 \
    /// Requests a single picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriendPopup(params:PickerFriendRequestParams, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, error)
            }
            else {
                self?.____sfp(params: params) { [weak self] selectedUsers, responseInfo, error in
                    completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 풀 스크린 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChat(params:PickerChatRequestParams, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____sc(params: params) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 팝업 형태의 채팅방 피커 요청 \
    /// Requests a chat picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChatPopup(params:PickerChatRequestParams, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____scp(params: params) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 풀 스크린 형태의 탭 피커 요청 \
    /// Requests a tap picker in full-screen view
    /// ## SeeAlso 
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func select(params:PickerTabRequestParams, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____s(params: params) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 팝업 형태의 탭 피커 요청 \
    /// Requests a tap picker in pop-up view
    /// ## SeeAlso 
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectPopup(params:PickerTabRequestParams, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____sp(params: params) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
}
