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

/// 채팅방 멤버 목록 \
/// List of chat members
/// ## SeeAlso 
/// - ``KakaoSDKTalk/TalkApi/chatMembers(chatId:friendsOnly:includeProfile:token:completion:)``
public struct ChatMembers : Codable {
    
    /// 채팅방 타입 \
    /// Type of the chat
    public let type: String     // TODO: enum
    
    /// 채팅방 멤버 목록 \
    /// List of chat members
    /// ## SeeAlso 
    /// - ``Member``
    public let members: [Member]?
    
    /// 채팅방 내 멤버 수(최대:500) \
    /// Number of chat members (Maximum: 500)
    public let activeMembersCount: Int?
    
    /// 채팅방 내 친구 수, `friendsOnly`를 `true`로 요청한 경우에만 응답에 포함(최대:500) \
    /// Number of friends in the chat room, only included in the response if `friendsOnly` is requested as `true` (Maximum: 500)
    public let activeFriendsCount: Int?
    
    /// 요청에 대한 토큰 정보 \
    /// Token for the request
    public let token: Int64?
}

/// 채팅방 멤버 \
/// Member of the cat
public struct Member : Codable {
    
    /// 앱 연결 여부 \
    /// Whether linked to the app
    public let appRegistered: Bool?

    /// 회원번호 \
    /// Service user ID
    public let id: Int64?
    
    /// 고유 ID \
    /// Unique ID
    public let uuid: String
    
    /// 프로필 닉네임 \
    /// Profile nickname
    public let nickname: String?
    
    /// 프로필 썸네일 이미지 \
    /// Profile thumbnail image
    public let thumbnailImageUrl: URL?
    
    /// 메시지 수신 허용 여부 \
    /// Whether to allow receiving messages
    public let msgBlocked: Bool?
    
    enum CodingKeys : String, CodingKey {
        case id, uuid, appRegistered, nickname, msgBlocked
        case thumbnailImageUrl = "thumbnailImage"
    }
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif 
    /// Decodable
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? values.decode(Int64.self, forKey: .id)
        uuid = try values.decode(String.self, forKey: .uuid)
        appRegistered = try? values.decode(Bool.self, forKey: .appRegistered)
        nickname = try? values.decode(String.self, forKey: .nickname)
        thumbnailImageUrl = URL(string:(try? values.decode(String.self, forKey: .thumbnailImageUrl)) ?? "")
        msgBlocked = try? values.decode(Bool.self, forKey: .msgBlocked)
    }
}
