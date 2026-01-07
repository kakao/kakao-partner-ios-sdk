//
//  SsoTokenInfo.swift
//  KakaoPartnerSDK
//
//  Created by kakao on 8/27/25.
//  Copyright © 2025 apiteam. All rights reserved.
//

import Foundation
import KakaoSDKCommon

/// 카카오톡 사용자 정보 \
///  Kakao Talk user information
public struct TalkUser {
    /// 사용자 ID \
    /// User ID
    public let id: String
    /// 카카오톡 닉네임 \
    /// Kakao Talk nickname
    public let nickName: String
    /// 카카오톡 계정에 연결된 사용자의 이메일 또는 전화번호 \
    /// User's email or phone number linked to Kakao Talk account
    public let displayId: String
    /// 카카오톡 프로필 썸네일 \
    /// Kakao Talk profile thumbnail
    public let thumbnailUrl: String?
    /// 카카오 통합서비스약관 동의 여부 \
    /// Whether the user has agreed to Kakao unified terms of service
    public let isUnifiedTermsAgreed: Bool    
    /// 카카오톡 계정 세션 만료 여부 \
    /// Whether the Kakao Talk account session is expired
    public let isExpired: Bool
    
    init(id: String, name: String, displayId: String, thumbnailUrl: String?, isUnifiedTermsAgreed: Bool, isExpired: Bool) {
        self.id = id
        self.nickName = name
        self.displayId = displayId
        self.thumbnailUrl = thumbnailUrl
        self.isUnifiedTermsAgreed = isUnifiedTermsAgreed
        self.isExpired = isExpired
    }
}

struct SsoInfo: Codable {
    let userId: String
    let accessToken: String
    let refreshToken: String
    let lastLoginDate: Date
    let isUnifiedTermsAgreed: Bool
    let user: SsoInfo.User
}

extension SsoInfo {
    public struct User: Codable {
        let nickName: String
        let displayId: String
        let thumbnailUrl: String?
    }
}

struct SsoInfos: Codable {
    let infos: [SsoInfo]
    
    func activeTokenInfo() -> SsoInfo? {
        return infos.sorted { $0.lastLoginDate > $1.lastLoginDate }.first
    }
    
    func isEmpty() -> Bool {
        return infos.isEmpty
    }
    
    func getInfoByRT(_ refreshToken: String) -> SsoInfo? {
        return infos.first { $0.refreshToken == refreshToken }
    }
}

struct InvalidElements: Codable {
    var elements: [String: String] = [:]
    
    mutating func append(_ info: SsoInfo) {
        elements[info.userId] = info.refreshToken
    }
    
    mutating func updateInvalidElements(ssoInfos: SsoInfos?) {
        guard let ssoInfos = ssoInfos else { return }
        for info in ssoInfos.infos {
            if let savedRt = elements[info.userId] {
                if savedRt != info.refreshToken {
                    elements.removeValue(forKey: info.userId)
                }
            }
        }
    }
    
    func contains(_ userId: String) -> Bool {
        return elements.keys.contains(userId)
    }
}

/// 멀티 계정 지원을 위한 계정 타입 \
/// Account type for multi-account support
public enum SsoLoginType {
    /// 카카오톡 실행 후 처음 로그인한 카카오톡 계정 \
    /// The first Kakao Talk account logged in after Kakao Talk is launched
    case main
    /// 현재 카카오톡에 활성화되어 있는 계정 \
    /// The current active account in Kakao Talk
    case active
}
