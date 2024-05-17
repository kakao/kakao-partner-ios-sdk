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

/// 채팅방 목록 \
/// List of chats
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/chatList(filters:offset:limit:order:completion:)``
public struct Chats : Codable {
    
    /// 채팅방 수 \
    /// Number of chats
    public let totalCount: Int
    
    /// 채팅방 목록 \
    /// List of chats
    /// ## SeeAlso 
    /// - ``Chat``
    public let elements: [Chat]?
    
    /// 이전 페이지 URL \
    /// URL for the prior page
    public let beforeUrl : URL?
    
    /// 다음 페이지 URL \
    /// URL for the next page
    public let afterUrl : URL?
    
}

/// 채팅방 타입 \
/// Type of the chat
public enum ChatRoomType : String, Codable {
    ///메모 챗방
    case MemoChat
    
    ///1:1 일반 챗방
    case DirectChat //기존 regular
    
    ///그룹 일반 챗방
    case MultiChat //기존 regular
    
    ///1:1 오픈 챗방
    case OpenDirectChat //기존 open
    
    ///그룹 오픈 챗방
    case OpenMultiChat //기존 open
}

/// 채팅방 정보 \
/// Chat information
public struct Chat : Codable {
    
    /// 채팅방 ID \
    /// Chat ID
    public let id: Int64
    
    /// 채팅방 이름 \
    /// Title of the chat
    public let title: String?
    
    /// 채팅방 이미지 URL \
    /// Image URL for the chat
    public let imageUrl: URL?
    
    /// 채팅방 멤버 수 \
    /// Number of chat members
    public let memberCount: Int?
    
    /// 채팅방 멤버 썸네일 이미지 목록(최대 5명) \
    /// List of thumbnail image of chat members (Maximum: 5)
    public let displayMemberImages: [URL]?
    
    /// 채팅방 타입 \
    /// Type of the chat
    public let roomType: ChatRoomType
    
    /// 채팅방 이름 타입(`user`: 사용자 설정 | `chat`: 채팅방 생성 시 설정 | `default`: 별도 설정 없음) \
    /// Type of the chat title (`user`: user set | `chat`: set upon creation | `default`: no setting)
    public let titleSource: String
    
    enum CodingKeys : String, CodingKey {
        case id, title, imageUrl, memberCount, displayMemberImages, roomType = "chatRoomType", titleSource
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int64.self, forKey: .id)
        title = try? values.decode(String.self, forKey: .title)
        imageUrl = URL(string:(try? values.decode(String.self, forKey: .imageUrl)) ?? "")
        memberCount = try? values.decode(Int.self, forKey: .memberCount)
        if let images = try? values.decode([URL].self, forKey: .displayMemberImages), images.count > 0 {
            displayMemberImages = images
        }
        else {
            displayMemberImages = nil
        }
        
        roomType = try values.decode(ChatRoomType.self, forKey: .roomType)
        titleSource = try values.decode(String.self, forKey: .titleSource)
    }
}
