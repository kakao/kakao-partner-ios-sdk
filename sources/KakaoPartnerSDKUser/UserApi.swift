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

/// 사용자관리 API 호출을 담당하는 클래스입니다.
extension UserApi {
    // MARK: Login with Kakao Account
    
    /// 카카오계정 페이지에서 로그인합니다. 이 API는 기본 브라우저의 쿠키 유무를 확인하지 않고 카카오계정 페이지를 호출하며, 추가 파라미터 "accountParameters"를 지원합니다.
    /// 현재 카카오계정 페이지 호출 시 자동 채우기(fill-in)를 위한 "email" 키를 사용할 수 있습니다.
    public func loginWithKakaoAccount(accountParameters: [String:String], completion: @escaping (OAuthToken?, Error?) -> Void) {
        AuthController.shared.authorizeWithAuthenticationSession(accountParameters: accountParameters,
                                                                 completion:completion)
    } 
    
    /// 사용자에 대한 다양한 정보를 얻을 수 있습니다.
    /// - seealso: `PartnerUser`
    public func meForPartner(propertyKeys: [String]? = nil,
                             secureResource: Bool = true,
                             completion:@escaping (PartnerUser?, Error?) -> Void) {
        AUTH.responseData(.get,
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
    
    /// 앱 연결 상태가 **PREREGISTER** 상태의 사용자에 대하여 앱 연결 요청을 합니다. **자동연결** 설정을 비활성화한 앱에서 사용합니다. 요청에 성공하면 사용자 아이디가 반환됩니다.
    public func signupForPartner(completion:@escaping (Int64?, Error?) -> Void) {
        PARTNER_AUTH.responseData(.post,
                          Urls.compose(path:PartnerPaths.signup),
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
    
    /// 연령인증이 필요한 시점(예를 들어, 인증후 90일 초과 시점, 결제전)에 인증여부/정보(인증 방식/제한나이 이상여부/인증날짜/CI값...)를 확인하기 위해 호출합니다.
    /// - parameters:
    ///   - ageLimit 연령제한 (만 나이 기준)
    ///   - propertyKeys 추가 동의를 필요로 하는 인증 정보를 응답에 포함하고 싶은 경우, 해당 키 리스트
    public func ageAuthInfo(ageLimit: Int? = nil, propertyKeys: [String]? = nil, completion:@escaping (AgeAuthInfo?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:PartnerPaths.ageAuthInfo),
                          parameters: ["age_limit":ageLimit, "property_keys": propertyKeys?.toJsonString()].filterNil(),
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
    
    
    /// 요청한 동의 항목(Scope)을 사용자가 동의한 동의 항목으로 추가합니다.
    /// 사용자로부터 동의를 받는 주체가 공동체이고 명시적인 제3자 제공 동의 화면을 제공하지 않을 경우, 동의 항목 추가하기 API가 아닌 추가 항목 동의 받기 API를 사용할 것을 권장합니다.
    /// 이 API는 권한이 필요하므로 권한: 인하우스 앱 또는 권한: 공동체 앱을 참고합니다.
    /// - parameters:
    ///   - scopes 추가할 동의 항목 ID 목록
    ///   - guardianToken 14세 미만 사용자인 경우 필수. 14세 미만 사용자의 동의 항목을 추가하기 위해 필요한 보호자인증 토큰
    public func upgradeScopes(scopes:[String], guardianToken: String? = nil, completion:@escaping (ScopeInfo?, Error?) -> Void) {
        AUTH.responseData(.post,
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
}
