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

/// 카카오톡 채팅방 목록 조회 API 응답 클래스입니다.
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/chatList(filters:offset:limit:order:completion:)``
public struct Chats : Codable {
    
    /// 전체 채팅방 수
    public let totalCount: Int
    
    /// 채팅방 목록
    /// ## SeeAlso 
    /// - ``Chat``
    public let elements: [Chat]?
    
    /// 채팅방 목록 현재 페이지의 이전 페이지 URL
    public let beforeUrl : URL?
    
    /// 채팅방 목록 현재 페이지의 다음 페이지 URL
    public let afterUrl : URL?
    
}

/// 선택한 채팅방의 종류
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

/// 카카오톡 채팅방을 나타냅니다.
public struct Chat : Codable {
    
    /// 채팅방 아이디
    public let id: Int64
    
    /// 채팅방 이름
    public let title: String?
    
    /// 이미지 URL
    public let imageUrl: URL?
    
    /// 참여한 멤버 수
    public let memberCount: Int?
    
    /// 화면에 표시할 대표 멤버 이미지 URL 목록
    public let displayMemberImages: [URL]?
    
    /// 채팅방의 종류
    public let roomType: ChatRoomType
    
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
