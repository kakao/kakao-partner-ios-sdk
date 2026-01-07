//
//  SsoProvider.swift
//  KakaoPartnerSDK
//
//  Created by kakao on 8/27/25.
//  Copyright © 2025 apiteam. All rights reserved.
//

import Foundation
import Security

import KakaoSDKCommon
import KakaoPartnerSDKCommon

final class SsoProvider {
    let dataHelper: DataHelper    
    private var invalidateElementsCache: InvalidElements
    
    init(dataHelper: DataHelper) {
        self.dataHelper = dataHelper
        invalidateElementsCache = dataHelper.invalidate() ?? InvalidElements()
    }
    
    func retrieveTokenInfos() throws -> SsoInfos? {
        let ssoInfos: SsoInfos? = try dataHelper.retrieveInfos()
        invalidateElementsCache.updateInvalidElements(ssoInfos: ssoInfos)
        
        return ssoInfos
    }
    
    func ssoInfo(type: SsoLoginType) -> SsoInfo? {
        do {
            let ssoInfos = try retrieveTokenInfos()
            return selectSsoInfo(type: type, ssoInfos: ssoInfos)
        } catch let error {
            SdkLog.d("Error refreshing token: \(error)")
            return nil
        }
    }
    
    private func selectSsoInfo(type: SsoLoginType, ssoInfos: SsoInfos?) -> SsoInfo? {
        if type == .active {
            let sorted = ssoInfos?.infos.sorted(by: { $0.lastLoginDate > $1.lastLoginDate })
            return sorted?.first
        }
        
        return ssoInfos?.infos.first
    }
    
    func invalidateToken(refreshToken: String) {
        do {
            let infos = try retrieveTokenInfos()
            if let invalidInfo = infos?.getInfoByRT(refreshToken) {
                invalidateElementsCache.append(invalidInfo)
            }
                        
            dataHelper.saveInvalidate(invalidateElementsCache)
        } catch let error {
            SdkLog.i("Failed to invalidate token: \(error)")
            return
        }
    }
    
    func isValidToken(userId: String) -> Bool {
        if invalidateElementsCache.contains(userId) {
            return false
        }
        
        return true
    }
}

final class SsoFactory {
    static func createSsoStore(groupName: String) -> SsoProvider {
        return SsoProvider(dataHelper: SsoDataHelper(groupName: groupName))
    }
}
