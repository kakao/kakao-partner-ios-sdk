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
import KakaoPartnerSDKAuth

///사용자의 연령인증 정보를 제공합니다.
public struct AgeAuthInfo : Codable {
    
    ///id 인증 여부를 확인하는 user의 id
    public let id : Int64?
    
    ///auth_level 유저가 받은 인증레벨. AUTH_LEVEL1, AUTH_LEVEL2 중 하나.
    public let authLevel : AuthLevel?
    
    ///authLevelCode 1 (auth_level : AUTH_LEVEL1) / 2 (auth_level : AUTH_LEVEL2)
    public let authLevelCode: Int?
    
    ///bypassAgeLimit true : 인증 받은 연령이 제한 나이 이상 / false : 인증 받은 연령이 제한 나이 미만
    public let bypassAgeLimit : Bool?
    
    ///authenticatedAt 인증 받은 시각. RFC3339 internet date/time format
    public let authenticatedAt : Date?
    
    ///ciNeedsAgreement 사용자 동의를 받으면 ci를 가지고 갈 수 있는지 여부
    public let ciNeedsAgreement : Bool?
    
    ///ci 인증후 받은 CI 값
    public let ci : String?
    
}
