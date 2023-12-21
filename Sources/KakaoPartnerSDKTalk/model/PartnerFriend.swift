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

/// 친구 목록 필터링
public enum FriendFilter : String, Codable {
    
    /// 필터링하지 않음
    case None = "none"
    
    /// 앱에 가입된 친구만 조회
    case Registered = "registered"
    
    /// 앱에 가입되지 않은 친구만 조회
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

/// 채팅방 목록 필터링 옵션
public enum ChatFilter {
    
    /// 1:1 채팅방만 필터링하여 결과에 포함시킨다.
    case Direct
    
    /// 그룹 채팅방만 필터링하여 결과에 포함시킨다.
    case Multi
    
    /// 일반 채팅방만 필터링하여 결과에 포함시킨다.
    case Regular
    
    /// 오픈 채팅방만 필터링하여 결과에 포함시킨다.
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

/// 파트너용으로 제공되는 친구 정보입니다. 보다 자세한 사용법은 Open SDK의 Friends 문서를 참고해주세요.
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/friendsForPartner(friendFilter:friendOrder:offset:limit:order:countryCodes:completion:)``
public struct PartnerFriend : Codable {
    
    /// 사용자의 현재 앱 가입 여부
    public let appRegistered: Bool?
    
    /// 사용자 아이디. appRegistered가 false이면 nil이 됩니다.
    public let id: Int64?
    
    /// 메시지를 전송하기 위한 고유 아이디
    ///
    /// 카카오 서비스의 회원임을 앱내에서 식별 할 수 있지만, 사용자의 계정 상태에 따라 이 정보는 바뀔 수 있습니다. 앱내의 사용자 식별자로 저장 사용되는 것은 권장하지 않습니다.
    public let uuid: String
    
    /// 친구의 대표 프로필 닉네임. 앱 가입친구의 경우 앱에서 설정한 닉네임. 미가입친구의 경우 톡 또는 스토리의 닉네임
    public let profileNickname: String?
    
    /// 친구의 썸네일 이미지 URL
    public let profileThumbnailImage: URL?
    
    /// 톡에 가입된 기기의 os 정보 (android / ios)
    public let talkOs: String?
    
    ///  메시지 수신이 허용되었는지 여부. 앱가입 친구의 경우는 feed msg에 해당. 앱미가입친구는 invite msg에 해당
    public let allowedMsg: Bool?
    
    /// 현재 사용자와의 친구 상태
    /// ## SeeAlso 
    /// - ``FriendRelation``
    public let relation: FriendRelation?
    
    /// 즐겨찾기 추가 여부
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

/// 친구 추가 상태 열거형
public enum FriendRelationType : String, Codable {
    
    /// 친구인 상태
    case Friend = "friend"
    
    /// 친구가 아닌 상태
    case NoFriend = "no_friend"
    
    /// 상태를 알 수 없음
    case NA = "N/A"
}

/// 카카오톡 추가 상태를 나타냅니다.
/// ## SeeAlso 
/// - ``FriendRelationType``
public struct FriendRelation : Codable {
    
    /// 카카오톡 친구 추가 상태
    public let talk: FriendRelationType?
}

/// 친구 목록 조회 컨텍스트
/// ## SeeAlso
/// - ``KakaoSDKTalk/TalkApi/friendsForPartner(context:completion:)``
public struct PartnerFriendsContext {
    public let friendFilter : FriendFilter?
    public let friendOrder : FriendOrder?
    public let offset : Int?
    public let limit : Int?
    public let order : Order?
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
