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

/// 채팅방 멤버 조회 API 응답 클래스
/// ## SeeAlso 
/// - ``TalkApi/chatMembers(chatId:friendsOnly:includeProfile:secureResource:offset:limit:order:)``
public struct ChatMembers : Codable {
    
    /// 채팅방 타입. "Direct", "Multi"
    public let type: String     // TODO: enum
    
    /// 멤버 목록
    /// ## SeeAlso 
    /// - ``Member``
    public let members: [Member]?
    
    /// 내려받은 멤버 목록의 수 (최대 500)
    public let activeMembersCount: Int?
    
    /// 내려받은 멤버 중 친구의 수
    public let activeFriendsCount: Int?
}

/// 채팅방 멤버
public struct Member : Codable {
    
    /// 사용자의 현재 앱 가입 여부
    public let appRegistered: Bool?

    /// 사용자 아이디. appRegistered가 false이면 값이 nil이 됩니다.
    public let id: Int64?
    
    /// 메시지를 전송하기 위한 고유 아이디
    ///
    /// 카카오 서비스의 회원임을 앱내에서 식별 할 수 있지만, 사용자의 계정 상태에 따라 이 정보는 바뀔 수 있습니다. 앱내의 사용자 식별자로 저장 사용되는 것은 권장하지 않습니다.
    public let uuid: String
    
    /// 카카오톡 닉네임
    public let nickname: String?
    
    /// 카카오톡 썸네일 이미지 URL
    public let thumbnailImageUrl: URL?
    
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
