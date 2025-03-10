//  Copyright 2025 Kakao Corp.
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

/// 서비스 앱 정보
public struct TargetInfo {
    /// 서비스 앱의 네이티브 앱 키
    let appKey: String
    /// 서비스 앱의 번들 ID
    let bundleId: String
    /// 서비스 앱의 accessToken
    let accessToken: String
    /// 카카오 API 호스트
    let kapiHost: String
    let kaHeader: String
    /// 서비스 앱의 헤더 정보
    var targetKaHeader: String!
    
    public init(appKey: String, bundleId: String, accessToken: String) {
        self.appKey = appKey
        self.bundleId = bundleId
        self.accessToken = accessToken
        self.kapiHost = KakaoSDK.shared.hosts().kapi
        self.kaHeader = Constants.kaHeader
        
        targetKaHeader = createTargetKaHeader()
    }
    
    private mutating func createTargetKaHeader() -> String {
        var currentKaHeader = kaHeader
        
        if let originAppBundleId = Bundle.main.bundleIdentifier {
            let replaceKey = "origin/\(originAppBundleId)"
            currentKaHeader = currentKaHeader.replacingOccurrences(of: replaceKey, with: "origin/\(bundleId)")
        }
        
        return currentKaHeader
    }
}
