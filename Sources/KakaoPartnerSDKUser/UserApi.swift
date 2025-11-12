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
import Alamofire
import KakaoPartnerSDKCommon
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import KakaoPartnerSDKAuth

/// 제한 연령 만족 여부 계산 기준 \
/// Criteria to determine whether the user meets the age limit
public enum AgeCriteria: String {
    /// 만 나이, 0에서 생일마다 1씩 증가하는 값 \
    /// International age
    case International = "international"
    
    /// 연 나이, 현재 연도에서 출생연도를 뺀 값 \
    /// Year age
    case Year = "year"
}

/// [카카오 로그인](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) API 클래스 \
/// Class for the [Kakao Login](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) APIs
extension UserApi {
    // MARK: Login with Kakao Account

#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    public func loginWithKakaoAccount(accountParameters: [String:String]? = nil, completion: @escaping (OAuthToken?, Error?) -> Void) {
        AuthController.shared._authorizeWithAuthenticationSession(accountParameters: accountParameters,
                                                                  completion:completion)
    }
    
    
    /// 사용자 정보 조회 \
    /// Retrieve user information
    /// - parameters:
    ///   - propertyKeys: 사용자 프로퍼티 키 목록 \
    ///                   List of user property keys to retrieve
    ///   - secureResource: 이미지 URL 값 HTTPS 여부 \
    ///                     Whether to use HTTPS for the image URL
    /// ## SeeAlso
    /// - ``PartnerUser``
    public func meForPartner(propertyKeys: [String]? = nil,
                             secureResource: Bool = true,
                             completion:@escaping (PartnerUser?, Error?) -> Void) {
        AUTH_API.responseData(.get,
                          Urls.compose(path:Paths.userMe),
                          parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                completion(try? SdkJSONDecoder.customIso8601Date.decode(PartnerUser.self, from: data), nil)
                                return
                            }

                            completion(nil, SdkError())
        }
    }
    
    /// 수동 연결 \
    /// Manual signup
    /// - parameters:
    ///   - properties: 사용자 프로퍼티 \
    ///                 User properties
    public func signupForPartner(properties: [String:String]? = nil,
                                 completion:@escaping (Int64?, Error?) -> Void) {
        PARTNER_AUTH_API.responseData(.post,
                          Urls.compose(path:PartnerPaths.signup),
                          parameters: ["properties": properties?.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                                    if let id = json["id"] as? Int64 {
                                        completion(id, nil)
                                        return
                                    }
                                }
                            }

                            completion(nil, SdkError())
        }
    }
    
    /// 연령인증 정보 조회 \
    /// Check age verification information
    /// - parameters:
    ///   - ageLimit: 제한 연령 만족 여부를 판단하는 기준 제한 연령 \
    ///               Age to determine whether the user is satisfied age limit
    ///   - ageCriteria: 제한 연령 만족 여부 계산 기준 \
    ///                  Criteria to determine whether the user is satisfied age limit
    ///   - propertyKeys: 카카오계정 CI 값 대조가 필요한 경우 사용 \
    ///                   Used to compare CI of Kakao Account
    /// ## SeeAlso
    /// - ``AgeAuthInfo``
    public func ageAuthInfo(ageLimit: Int? = nil, ageCriteria: AgeCriteria? = nil, propertyKeys: [String]? = nil, completion:@escaping (AgeAuthInfo?, Error?) -> Void) {
        AUTH_API.responseData(.get,
                          Urls.compose(path:PartnerPaths.ageAuthInfo),
                              parameters: ["age_limit":ageLimit, "age_criteria":ageCriteria?.rawValue, "property_keys": propertyKeys?.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                completion(try? SdkJSONDecoder.customIso8601Date.decode(AgeAuthInfo.self, from: data), nil)
                                return
                            }

                            completion(nil, SdkError())
        }
    }
    
    
    /// 동의항목 동의 처리 \
    /// Upgrade scopes
    /// - parameters:
    ///   - scopes: 동의항목 ID 목록 \
    ///             Scope IDs
    ///   - guardianToken: 14세 미만 사용자의 동의항목을 추가하기 위해 필요한 보호자인증 토큰 \
    ///                    Parental authorization token to upgrade scope for the users under 14 years old
    /// ## SeeAlso
    /// - [`ScopeInfo`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/scopeinfo)
    public func upgradeScopes(scopes:[String], guardianToken: String? = nil, completion:@escaping (ScopeInfo?, Error?) -> Void) {
        AUTH_API.responseData(.post,
                          Urls.compose(path:PartnerPaths.userUpgradeScopes),
                          parameters: ["scopes":scopes.toJsonString(), "guardian_token":guardianToken].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(ScopeInfo.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    
    /// 연령인증 페이지 호출 \
    /// Request age verification
    /// - parameters:
    ///   - authLevel: 연령인증 레벨 \
    ///                Age verification level
    ///   - ageLimit: 제한 연령 \
    ///               Age limit
    ///   - skipTerms: 동의 화면 출력 여부 \
    ///                Whether to display the consent screen
    ///   - adultsOnly: 서비스의 청소년유해매체물 인증 필요 여부 \
    ///                 Whether the service requires age verification due to the media harmful to youth
    ///   - underAge: 연령인증 페이지 구분 여부(기본값: `false`) \
    ///               Whether to separate age verification pages (default: `false`)
    /// ## SeeAlso
    ///  - ``signupForPartner(properties:completion:)``
    public func verifyAge(authLevel: AuthLevel? = nil,
                              ageLimit: Int? = nil,
                              skipTerms: Bool? = false,
                              adultsOnly: Bool? = false,
                              underAge: Bool? = false,
                              completion: @escaping (Error?) -> Void) {
        AuthController.shared.verifyAgeWithAuthenticationSession(authLevel: authLevel,
                                                                 ageLimit: ageLimit,
                                                                 skipTerms: skipTerms,
                                                                 adultsOnly: adultsOnly,
                                                                 underAge: underAge,
                                                                 completion: completion)
    }
    
    /// 배송지 추가 \
    /// Create shipping address
    public func createShippingAddress(completion: @escaping (Int64?, Error?) -> Void) {
        self._requestShippingAddress(continuePath: PartnerPaths.createAddress,
                                     completion: completion)
    }
    
    /// 배송지 수정 \
    /// Update shipping address
    /// - parameters:
    ///   - addressId: 배송지 ID \
    ///                Shipping address ID
    public func updateShippingAddress(addressId: Int64, completion: @escaping (Int64?, Error?) -> Void) {
        self._requestShippingAddress(continuePath: PartnerPaths.editAddress,
                                     addressId: addressId, 
                                     completion: completion)
    }
}

extension UserApi {
    /// SSO 시도 전, 접근하고자 하는 키체인 액세스 그룹 초기화 \
    /// Initializes access group for keychain prior to SSO attempt
    /// - parameters:
    ///   - groupName: 사용할 액세스 그룹 이름 \
    ///                access group name to use
    public func prepareForSso(groupName: String) {
        _storeHelper = SsoFactory.createSsoStore(groupName: groupName)
    }
    
    /// SSO 기능 사용 가능 여부, 사용자의 카카오톡 로그인 여부와 무관 \
    /// Whether SSO feature is available, regardless of user's Kakao Talk login.
    public func isSsoLoginAvailable() -> Bool {
        guard let storeHelper = _storeHelper as? SsoProvider else {
            return false
        }
#if !targetEnvironment(simulator)
        if UserApi.isKakaoTalkLoginAvailable() == false {
            return false
        }
#endif

        do {
            let tokenInfos = try storeHelper.retriveTokenInfos()
            SdkLog.d("ssoTokenInfos: \(String(describing: tokenInfos))")
            
            if tokenInfos == nil || tokenInfos?.isEmpty() == true {
                return false
            }
        } catch let error {
            SdkLog.d("Failed to retrive token infos OSStatus: \(error)")
            return false
        }
        
        return true
    }
    
    /// 키체인에 등록된 카카오톡 사용자 정보 조회 (id, 이메일, 닉네임, 프로필 이미지, 통합 약관 동의 여부) \
    /// Retrieves information of Kakao Talk accounts registered in keychain (id, email, nickname, profile image, wheter the user has agreed to unified terms of service)
    public func getTalkUsers() -> [TalkUser] {
        guard let storeHelper = _storeHelper as? SsoProvider else {
            return []
        }
        
        do {
            let infos = try storeHelper.retriveTokenInfos()?.infos
            let talkUsers = infos?.compactMap({ info in
                return TalkUser(
                    id: info.userId,
                    name: info.user.nickName,
                    displayId: info.user.displayId,
                    thumbnailUrl: info.user.thumbnailUrl,
                    isUnifiedTermsAgreed: info.isUnifiedTermsAgreed
                )
            })
            
            return talkUsers ?? []
        } catch {
            return []
        }
    }
    
    /// SSO 인증 \
    /// SSO authentication
    /// - parameters:
    ///    - type: 로그인할 계정 타입 \
    ///            Account type to login with
    ///    - useUnifiedTerms: 통합 서비스 약관 사용 여부, 통합 서비스약관을 사용하는 서비스에서는 true 설정 \
    ///                       Whether to use Kakao Comprehensive Terms of Service. Set to true if your service uses Kakao Comprehensive Terms of Service.
    public func sso(_ type: SsoLoginType = .active, useUnifiedTerms: Bool = false, completion: @escaping (OAuthToken?, Error?) -> Void) {
        guard let storeHelper = _storeHelper as? SsoProvider else {
            completion(nil, SdkError(reason: .IllegalState, message: "SSO is not prepared"))
            return
        }
        
        guard let ssoInfo = storeHelper.appropriateInfo(type: type) else {
            completion(nil, SdkError(reason: .IllegalState, message: "RefreshToken is not available"))
            return
        }
        
        if useUnifiedTerms == true && ssoInfo.isUnifiedTermsAgreed == false {
            completion(nil, SdkError(reason: .IllegalState, message: "There are no accounts available for SSO."))
        }
        
        requestSso(refreshToken: ssoInfo.refreshToken, completion: completion)
    }
    
    /// 커스텀 SSO 인증 \
    /// Custom SSO authentication
    /// - parameters:
    ///    - id: getTalkUsers()로 얻은 사용자 ID \
    ///          User ID obtained via getTalkUsers()
    public func sso(id: String, completion: @escaping (OAuthToken?, Error?) -> Void) {
        guard let storeHelper = _storeHelper as? SsoProvider else {
            completion(nil, SdkError(reason: .IllegalState, message: "SSO is not prepared"))
            return
        }
        
        do {
            let infos = try storeHelper.retriveTokenInfos()?.infos
            if let ssoInfo = infos?.first(where: { $0.userId == id }) {
                requestSso(refreshToken: ssoInfo.refreshToken, completion: completion)
                return
            }
            
            completion(nil, SdkError(reason: .IllegalState, message: "No matching user id"))
        } catch {
            completion(nil, SdkError(reason: .IllegalState, message: "Failed to retrive token infos"))
        }
    }
    
    func requestSso(refreshToken: String, completion: @escaping (OAuthToken?, Error?) -> Void) {
        AuthController.shared._authorizeWithRefreshToken(refreshToken: refreshToken) { code, error in
            if let code {
                AuthApi.shared.token(code: code, codeVerifier: AuthController.shared.codeVerifier, completion: completion)
                return
            }
            
            let resultError = error ?? SdkError()
            completion(nil, resultError)
        }
    }
}
