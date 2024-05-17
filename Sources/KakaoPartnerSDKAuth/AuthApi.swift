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

/// [카카오 로그인](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common) 인증 및 토큰 관리 클래스 \
/// Class for the authentication and token management through [Kakao Login](https://developers.kakao.com/internal-docs/latest/ko/kakaologin/common)
extension AuthApi {
    
    /// 인가 코드로 토큰 발급 \
    /// Issues tokens with the authorization code
    /// - parameters:
    ///   - groupRefreshToken: 그룹 앱의 리프레시 토큰 \
    ///                        Refresh token of a group app
    /// ## SeeAlso
    /// - [`OAuthToken`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKAuth/documentation/kakaosdkauth/oauthtoken)
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
