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
    /// 친구 피커 \
    /// Friends picker
    /// ## SeeAlso 
    /// - [`PickerFriendRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerfriendrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    public func selectFriend(params:PickerFriendRequestParams, viewType: ViewType, enableMulti:Bool = true, completion:@escaping (SelectedUsers?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, error)
            }
            else {
                self?.____sf(params: params, enableMulti: enableMulti, viewType: viewType) { [weak self] selectedUsers, responseInfo, error in
                    completion(selectedUsers, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }

    /// 채팅방 피커 \
    /// Chat picker
    /// ## SeeAlso
    /// - [`PickerChatRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickerchatrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func selectChat(params:PickerChatRequestParams, viewType: ViewType, enableMulti:Bool = true, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____sc(params: params, enableMulti: enableMulti, viewType: viewType) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
    
    /// 탭 피커 \
    /// Tab picker
    /// ## SeeAlso
    /// - [`PickerTabRequestParams`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/pickertabrequestparams)
    /// - [`SelectedUsers`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedusers)
    /// - [`SelectedChat`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKFriendCore/documentation/kakaosdkfriendcore/selectedchat)
    public func select(params:PickerTabRequestParams, viewType: ViewType, enableMulti:Bool = true, completion:@escaping (SelectedUsers?, SelectedChat?, Error?) -> Void) {
        prepareCallPickerApi { [weak self] error in
            if let error = error {
                completion(nil, nil, error)
            }
            else {
                self?.____s(params: params, enableMulti: enableMulti, viewType: viewType) { [weak self] selectedUsers, selectedChat, responseInfo, error in
                    completion(selectedUsers, selectedChat, self?.castSdkError(responseInfo:responseInfo, error: error))
                }
            }
        }
    }
}
