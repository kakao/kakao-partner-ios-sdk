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
    
    init(dataHelper: DataHelper) {
        self.dataHelper = dataHelper        
    }
    
    func retriveTokenInfos() throws -> SsoInfos? {
        return try dataHelper.retriveInfos()
    }
    
    func appropriateInfo(type: SsoLoginType) -> SsoInfo? {
        do {
            let ssoInfos = try retriveTokenInfos()
            return selectSsoInfo(type: type, ssoInfos: ssoInfos)
        } catch let error {
            print("Error refreshing token: \(error)")
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
}

final class SsoFactory {
    static func createSsoStore(groupName: String) -> SsoProvider {
        return SsoProvider(dataHelper: SsoDataHelper(groupName: groupName))
    }
}
