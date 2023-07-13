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

/// 파트너용으로 제공되는 클래스로 챗방/챗멤버피커, 탭피커를 호출합니다.
extension PickerApi  {
    /// 여러 명의 친구를 선택(멀티 피커)할 수 있는 친구 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 여러 명의 친구를 선택(멀티 피커)할 수 있는 친구 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 한 명의 친구만 선택(싱글 피커)할 수 있는 친구 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 한 명의 친구만 선택(싱글 피커)할 수 있는 친구 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerFriendRequestParams`
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
    
    /// 채팅방 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerChatRequestParams`
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
    
    /// 채팅방 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerChatRequestParams`
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
    
    /// 친구 피커와 채팅방 피커를 탭 구조로 제공하는 탭 피커를 화면 전체에 표시합니다.
    /// - seealso: `PickerTabRequestParams`
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
    
    /// 친구 피커와 채팅방 피커를 탭 구조로 제공하는 탭 피커를 팝업 형태로 표시합니다.
    /// - seealso: `PickerTabRequestParams`
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
