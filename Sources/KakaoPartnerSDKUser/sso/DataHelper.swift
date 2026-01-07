//
//  SsoDataHelper.swift
//  KakaoPartnerSDK
//
//  Created by kakao on 9/18/25.
//  Copyright © 2025 apiteam. All rights reserved.
//

import Foundation
import Security

import KakaoSDKCommon

protocol DataHelper {
    func retrieveInfos() throws -> SsoInfos?
    func saveInvalidate(_ data: Codable)
    func invalidate() -> InvalidElements?
}

final class SsoDataHelper: DataHelper {
    private let invalidateKey = "com.kakao.sdk.sso.invalidate"
    
    var serviceName: String?
    let groupName: String
    
    init(groupName: String) {
        self.groupName = groupName
        self.serviceName = getServiceName()
        
        SdkLog.d("\(groupName) \(String(describing: serviceName))")
    }
    
    func retrieveInfos() throws -> SsoInfos? {
        guard let serviceName else { throw SdkError(reason: .IllegalState, message: "Sso service not prepared") }
        
        let keyChainQuery: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccessGroup as String: groupName,
            kSecReturnData as String: true,
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keyChainQuery, &item)
        let error = convertOsstatusToSsoError(status: status)
        
        if let data = item as? Data {
            return try? SdkJSONDecoder.default.decode(SsoInfos.self, from: data)
        }
        
        throw error ?? SdkError(reason: .Unknown, message: "Unknown error occurred while retrieving token infos from keychain" )
    }
    
    func saveInvalidate(_ data: Codable) {
        Properties.saveCodable(key: invalidateKey, data: data)
    }
    
    func invalidate() -> InvalidElements? {
        let elements: InvalidElements? = Properties.loadCodable(key: invalidateKey)
        return elements
    }
}

extension SsoDataHelper {
    private func convertOsstatusToSsoError(status: OSStatus) -> SdkError? {
        switch status {
        case errSecItemNotFound:
            return SdkError(reason: .IllegalState, message: "Keychain item not found")
        case errSecDuplicateItem:
            return SdkError(reason: .IllegalState, message: "Keychain item already exists")
        case errSecSuccess:
            return nil
        default:
            return SdkError(reason: .Unknown, message: "Keychain error with status: \(status)")
        }
    }
    
    private func getServiceName() -> String? {
        guard let serviceName = findServiceName(), !serviceName.isEmpty else {
            return nil
        }
        
        let phase = KakaoSDK.shared.currentPhase()
        switch phase {
        case .Dev, .Sandbox, .Cbt:
            let nameData = "\(serviceName).\(phase.rawValue)".data(using: .utf8) ?? Data()
            return SdkCrypto.shared.base64(data: nameData)
        default:
            let defaultData = serviceName.data(using: .utf8) ?? Data()
            return SdkCrypto.shared.base64(data: defaultData)
        }
    }
    
    private func findServiceName() -> String? {
        let keyChainQuery: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.kakao.sdk.sso.key",
            kSecAttrAccessGroup as String: groupName,
            kSecReturnData as String: true,
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keyChainQuery, &item)
        if status == errSecSuccess, let data = item as? Data {
            let bytes = [UInt8](data)
            return deobfuscate(input: bytes)
        }
        
        return nil
    }
    
    private func deobfuscate(input: [UInt8]) -> String {
        let deobfuscatedBytes = input.map { $0 ^ 0xAF }
        return String(bytes: deobfuscatedBytes, encoding: .utf8) ?? ""
    }
}
