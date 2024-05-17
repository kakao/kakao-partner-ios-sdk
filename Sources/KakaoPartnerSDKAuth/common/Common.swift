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

/// 연령인증 레벨 \
/// Age verification level
public enum AuthLevel : String, Codable {
    /// 1차, 연령인증 \
    /// Level 1, age verification
    case Level1 = "AUTH_LEVEL1"
    /// 2차, 본인인증 \
    /// Level 2, identity verification
    case Level2 = "AUTH_LEVEL2"
    
#if swift(>=5.8)
@_documentation(visibility: private)
#endif
    public var parameterValue: String {
        switch self {
        case .Level1:
            return "10"
        case .Level2:
            return "20"
        }
    }
}
