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
/// - seealso: `TalkApi.chatList(secureResource:offset:limit:order:)`
public struct Chats : Codable {
    
    /// 전체 채팅방 수
    public let totalCount: Int
    
    /// 채팅방 목록
    /// - seealso: `Chat`
    public let elements: [Chat]?
    
    /// 채팅방 목록 현재 페이지의 이전 페이지 URL
    public let beforeUrl : URL?
    
    /// 채팅방 목록 현재 페이지의 다음 페이지 URL
    public let afterUrl : URL?
    
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
    
    /// 채팅방의 종류(오픈채팅(open), 일반채팅(regular))
    public let chatType: String
    
    public let titleSource: String
    
    enum CodingKeys : String, CodingKey {
        case id, title, imageUrl, memberCount, displayMemberImages, chatType, titleSource
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
        
        chatType = try values.decode(String.self, forKey: .chatType)
        titleSource = try values.decode(String.self, forKey: .titleSource)        
    }
}
