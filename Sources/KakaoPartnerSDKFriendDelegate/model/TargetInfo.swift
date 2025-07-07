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

/// 친구 피커 요청을 위한 설정 정보
@objc(KakaoPartnersSDKFriendDelegate_ConfigInfo)
public class ConfigInfo: NSObject {
    public static let shared = ConfigInfo()
    
    /// 카카오 API 호스트
    public var kapiHost: String {
        guard let kapiHost = _kapiHost else {
            fatalError("KapiHost is not set.")
        }
        
        return kapiHost
    }
    
    /// API 요청을 위한 헤더 정보
    public var kaHeader: String {
        guard let kaHeader = _kaHeader else {
            fatalError("KaHeader is not set.")
        }
        
        return kaHeader
    }
    
    private var _kapiHost: String?
    private var _kaHeader: String?
    
    public func updateConfig(kapiHost: String, kaHeader: String) {
        _kapiHost = kapiHost
        _kaHeader = kaHeader
    }
}

/// 서비스 앱 정보
public struct TargetInfo {
    /// 서비스 앱의 네이티브 앱 키
    let appKey: String
    /// 서비스 앱의 번들 ID
    let bundleId: String
    /// 서비스 앱의 accessToken
    let accessToken: String
    /// 서비스 앱의 헤더 정보
    let targetKaHeader: String
    
    public init(appKey: String, bundleId: String, accessToken: String) {
        self.appKey = appKey
        self.bundleId = bundleId
        self.accessToken = accessToken
        
        targetKaHeader = TargetInfo.createTargetKaHeader(for: bundleId)
    }
    
    public init(appKey: String, bundleId: String, accessToken: String, originBundleId: String? = nil) {
        self.appKey = appKey
        self.bundleId = bundleId
        self.accessToken = accessToken
        
        targetKaHeader = TargetInfo.createTargetKaHeader(for: bundleId, originBundleId: originBundleId)
    }
    
    private static func createTargetKaHeader(for bundleId: String, originBundleId: String? = nil) -> String {
        var currentKaHeader = ConfigInfo.shared.kaHeader
        var originBundleId = originBundleId ?? Bundle.main.bundleIdentifier
        
        if let originAppBundleId = originBundleId {
            let replaceKey = "origin/\(originAppBundleId)"
            currentKaHeader = currentKaHeader.replacingOccurrences(of: replaceKey, with: "origin/\(bundleId)")
        }
        
        return currentKaHeader
    }
}
