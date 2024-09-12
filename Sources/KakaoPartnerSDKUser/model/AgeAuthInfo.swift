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

/// 사용자 연령인증 정보 \
/// User age verification information
public struct AgeAuthInfo : Codable {
    
    /// 회원번호 \
    /// Service user ID
    public let id : Int64?
    
    /// 연령인증 레벨 \
    /// Age verification level
    public let authLevel : AuthLevel?
    
    /// 연령인증 레벨 비교 편의를 위한 코드(`1`: `AUTH_LEVEL1` | `2`: `AUTH_LEVEL2`) \
    /// Reference code to compare the age verification level (`1`: `AUTH_LEVEL1` | `2`: `AUTH_LEVEL2`)
    public let authLevelCode: Int?
    
    /// 제한 연령 만족 여부 \
    /// Whether the user is satisfied age limit
    public let bypassAgeLimit : Bool?
    
    /// 인증 시각, RFC3339 Internet date/time format \
    /// Authentication time, RFC3339 Internet date/time format
    public let authenticatedAt : Date?
    
    /// CI 값 보유 여부 \
    /// Whether the user has a CI value
    public let hasCi: Bool?
    
}
