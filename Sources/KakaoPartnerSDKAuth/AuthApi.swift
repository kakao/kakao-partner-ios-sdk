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

/// 카카오 로그인 확장 모듈입니다. 확장 모듈이므로 KakaoSDKAuth 모듈에 대한 의존성이 필요합니다.
///
extension AuthApi {
    
    /// 그룹 내 다른 앱의 refreshToken으로 사용자를 인증하여 현재 앱의 토큰을 발급 받습니다.
    /// 이 기능을 사용하더라도 사용자 인증에 사용하는 refreshToken 값을 앱 사이에 공유하지 않으며, 현재 앱을 위한 새로운 OAuthToken 세트가 발급됩니다.
    public func token(groupRefreshToken: String? = nil,
                      completion:@escaping (OAuthToken?, Error?) -> Void) {
        API.responseData(.post,
                        Urls.compose(.Kauth, path:Paths.authToken),
                        parameters: ["grant_type":"group_refresh_token",
                                     "client_id": try! KakaoSDK.shared.appKey(),
                                     "group_refresh_token":groupRefreshToken,
                                     "ios_bundle_id":Bundle.main.bundleIdentifier].filterNil(),
                        sessionType:.Auth,
                        apiType: .KAuth) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                if let oauthToken = try? SdkJSONDecoder.custom.decode(OAuthToken.self, from: data) {
                                    AUTH.tokenManager.setToken(oauthToken)
                                    completion(oauthToken, nil)
                                    return
                                }
                            }
                            completion(nil, SdkError())
                        }
    }
}
