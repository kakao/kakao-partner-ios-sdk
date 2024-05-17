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
import KakaoSDKCommon
import KakaoSDKTalk

// MARK: Enumerations

/// 친구 목록 필터링 설정 \
/// Filtering options for the friend list
public enum FriendFilter : String, Codable {
    
    /// 필터링하지 않음 \
    /// Do not filter
    case None = "none"
    
    /// 앱과 연결된 친구 \
    /// Friends linked to the app
    case Registered = "registered"
    
    /// 앱과 연결되지 않은 친구, 초대 가능 \
    /// Friends not linked to the app, available to invite
    case Invitable = "invitable"
    
//    public var parameterValue: String {
//        switch self {
//        case .None:
//            return "none"
//        case .Registered:
//            return "registered"
//        case .Invitable:
//            return "invitable"
//        }
//    }
}

/// 채팅방 필터링 설정 \
/// Filtering options for the chat
public enum ChatFilter {
    
    /// 1:1 채팅방만 포함 \
    /// Includes 1:1 chats only
    case Direct
    
    /// 그룹 채팅방만 포함 \
    /// Includes group chats only
    case Multi
    
    /// 일반 채팅방만 포함 \
    /// Includes regular chats only
    case Regular
    
    /// 오픈채팅방만 포함 \
    /// Includes open chats only
    case Open

    public var parameterValue: String {
        switch self {
        case .Direct:
            return "direct"
        case .Multi:
            return "multi"
        case .Regular:
            return "regular"
        case .Open:
            return "open"
        }
    }
}

/// 친구 정보 \
/// Friend information
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/friendsForPartner(friendFilter:friendOrder:offset:limit:order:countryCodes:completion:)``
public struct PartnerFriend : Codable {
    
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
    public let profileNickname: String?
    
    /// 프로필 썸네일 이미지 \
    /// Profile thumbnail image
    public let profileThumbnailImage: URL?
    
    /// 카카오톡 가입 기기 OS \
    /// Filtering options for the OS of the device used to sign up for Kakao Talk
    public let talkOs: String?
    
    /// 메시지 수신 허용 여부 \
    /// Whether to allow receiving messages
    public let allowedMsg: Bool?
    
    /// 사용자와 친구의 관계 \
    /// Relationship between user and friend
    public let relation: FriendRelation?
    
    /// 즐겨찾기 친구 여부 \
    /// Whether a favorite friend
    public let favorite: Bool?
    
    enum CodingKeys : String, CodingKey {
        case id, uuid, appRegistered, profileNickname, profileThumbnailImage, talkOs, allowedMsg, relation, favorite
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
        profileNickname = try? values.decode(String.self, forKey: .profileNickname)
        profileThumbnailImage = URL(string:(try? values.decode(String.self, forKey: .profileThumbnailImage)) ?? "")
        talkOs = try? values.decode(String.self, forKey: .talkOs)
        allowedMsg = try? values.decode(Bool.self, forKey: .allowedMsg)
        relation = try? values.decode(FriendRelation.self, forKey: .relation)
        favorite = try? values.decode(Bool.self, forKey: .favorite)
    }
}

/// 카카오톡 사용자와 친구의 관계 \
/// Relation between the user and the friend
public enum FriendRelationType : String, Codable {
    
    /// 친구인 상태
    case Friend = "friend"
    
    /// 친구가 아닌 상태
    case NoFriend = "no_friend"
    
    /// 상태를 알 수 없음
    case NA = "N/A"
}

/// 카카오톡 사용자와 친구의 관계 \
/// Relation between the user and the friend
/// ## SeeAlso 
/// - ``FriendRelationType``
public struct FriendRelation : Codable {
    
    /// 카카오톡 친구 추가 상태
    public let talk: FriendRelationType?
}

/// 친구 목록 조회 설정 \
/// Context for retrieving friend list
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/friendsForPartner(context:completion:)``
public struct PartnerFriendsContext {
    /// 친구 목록 필터링 설정 \
    /// Filtering options for the friend list
    public let friendFilter : FriendFilter?
    /// 친구 정렬 방식 \
    /// Method to sort the friend list
    public let friendOrder : FriendOrder?
    /// 친구 목록 시작 지점 \
    /// Start point of the friend list
    public let offset : Int?
    /// 페이지당 결과 수 \
    /// Number of results in a page
    public let limit : Int?
    /// 정렬 방식 \
    /// Sorting method
    public let order : Order?
    /// 국가 코드 필터링 설정 \
    /// Options for filtering by country codes
    public let countryCodes : [String]?
   
    public init(friendFilter : FriendFilter? = nil,
                friendOrder : FriendOrder? = nil,
                offset: Int? = nil,
                limit: Int? = nil,
                order: Order? = nil,
                countryCodes : [String]? = nil) {
        self.friendFilter = friendFilter
        self.friendOrder = friendOrder
        self.offset = offset
        self.limit = limit
        self.order = order
        self.countryCodes = countryCodes
    }
    
    public init?(_ url:URL?) {
        if let params = url?.params() {            
            if let friendFilter = params["friend_filter"] as? String { self.friendFilter = FriendFilter(rawValue: friendFilter) ?? .None } else { self.friendFilter = nil }
            if let friendOrder = params["friend_order"] as? String { self.friendOrder = FriendOrder(rawValue: friendOrder) ?? .Favorite } else { self.friendOrder = nil }
            if let offset = params["offset"] as? String { self.offset = Int(offset) ?? 0 } else { self.offset = nil }
            if let limit = params["limit"] as? String { self.limit = Int(limit) ?? 0 } else { self.limit = nil }
            if let order = params["order"] as? String { self.order = Order(rawValue: order) ?? .Asc } else { self.order = nil }
            if let countryCodes = params["country_codes"] as? String { self.countryCodes = countryCodes.components(separatedBy: ",") } else { self.countryCodes = nil }
        }
        else {
            return nil
        }
    }
}
