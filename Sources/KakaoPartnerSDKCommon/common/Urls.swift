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

/// 카카오 내부 Deployment Phase를 나타냅니다.
public enum Phase : String {
    /// Omega
    case Omega
    
    /// Alpha (Dev)
    case Dev
    
    /// Sandbox
    case Sandbox
    
    /// Beta (Cbt)
    case Cbt
    
    /// Real (Production)
    case Production
}

/// API 호출을 위한 호스트 정보를 갖고 있습니다. 내부 phase 용 인스턴스를 생성할 수 있습니다.
extension Hosts {
    @_documentation(visibility: public)
    /// 원하는 phase에 대한 호스트 정보를 생성합니다.
    public convenience init(phase:Phase) {
        switch phase {
        case .Omega:
            self.init(kapi: "omega-kapi.kakao.com",
                      dapi: "alpha-dapi.kakao.com",
                      auth: "omega-auth.kakao.com",
                      kauth: "omega-kauth.kakao.com",
                      talkAuth: "alphakompassauth",
                      channel: "alpha-pf.kakao.com",
                      talkLink: "alphalink",
                      talkLinkVersion: "alphatalk-5.9.7",
                      sharerLink: "alpha-sharer.devel.kakao.com",
                      universalLink: "alpha-talk-apps.kakao.com",
                      cert:"")
        case .Dev:
            self.init(kapi: "alpha-kapi.kakao.com",
                      dapi: "alpha-dapi.kakao.com",
                      auth: "alpha-auth.kakao.com",
                      kauth: "alpha-kauth.kakao.com",
                      talkAuth: "alphakompassauth",
                      channel: "alpha-pf.kakao.com",
                      talkLink: "alphalink",
                      talkLinkVersion: "alphatalk-5.9.7",
                      sharerLink: "alpha-sharer.devel.kakao.com",
                      universalLink: "alpha-talk-apps.kakao.com",
                      cert:"",
                      plusFriend: "alphaplus")
        case .Sandbox:
            self.init(kapi: "sandbox-kapi.kakao.com",
                      dapi: "sandbox-dapi.kakao.com",
                      auth: "sandbox-auth.kakao.com",
                      kauth: "sandbox-kauth.kakao.com",
                      talkAuth: "alphakompassauth",
                      channel: "sandbox-pf.kakao.com",
                      talkLink: "alphalink",
                      talkLinkVersion: "alphatalk-5.9.7",
                      sharerLink: "sandbox-sharer.devel.kakao.com",
                      universalLink: "sandbox-talk-apps.kakao.com",
                      cert:"sign-papi.sandbox.onkakao.net",
                      plusFriend: "alphaplus")
        case .Cbt:
            self.init(kapi: "beta-kapi.kakao.com",
                      dapi: "beta-dapi.kakao.com",
                      auth: "beta-auth.kakao.com",
                      kauth: "beta-kauth.kakao.com",
                      talkAuth: "kakaokompassauth",
                      channel: "beta-pf.kakao.com",
                      talkLink: "kakaolink",
                      talkLinkVersion: "kakaotalk-5.9.7",
                      sharerLink: "beta-sharer.devel.kakao.com",
                      universalLink: "beta-talk-apps.kakao.com",
                      cert:"cbt-cert-sign-papi.kakao.com",
                      plusFriend: "kakaoplus")
        default:
            self.init()
        }
    }
}

@_documentation(visibility: private)
public class PartnerPaths {
    public static let chatList = "/v1/api/talk/chat/list"
    public static let chatMembers = "/v1/api/talk/members"
    
    public static let customMessage = "/v2/api/talk/message/send"
    public static let defaultMessage = "/v2/api/talk/message/default/send"
    public static let scrapMessage = "/v2/api/talk/message/scrap/send"
    
    public static let friends = "/v1/friends"
    
    public static let signup = "/v1/user/signup"
    public static let userUpgradeScopes = "/v2/user/upgrade/scopes"
    
    public static let ageAuth = "/ageauths/main.html"
    public static let ageAuthInfo = "/v2/user/age_auth"
    
    public static let selectFriends = "/v1/friends/sdk"
    public static let userScpoes = "/v2/user/scopes/sdk"
    
    public static let selectChats = "/v1/api/talk/chat/list/sdk"
    public static let selectChatMembers = "/v1/api/talk/members/sdk"
}
