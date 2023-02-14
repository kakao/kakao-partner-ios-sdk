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

import UIKit
import SafariServices
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoPartnerSDKCommon

/// :nodoc:
@available(iOSApplicationExtension, unavailable)
let AUTH_CONTROLLER = AuthController.shared

/// :nodoc:
@available(iOSApplicationExtension, unavailable)
extension AuthController {
    
    /// :nodoc:
    public func verifyAgeWithAuthenticationSession(authLevel: AuthLevel? = nil,
                                                   ageLimit: Int? = nil,
                                                   skipTerms: Bool? = false,
                                                   adultsOnly: Bool? = false,
                                                   underAge: Bool? = false,
                                                   completion: @escaping (Error?) -> Void) {
        
        let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
            (callbackUrl:URL?, error:Error?) in
            
            guard let callbackUrl = callbackUrl else {
                if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                    if error.code == ASWebAuthenticationSessionError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        completion(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        return
                    } else {
                        SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                        completion(SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        return
                    }
                } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                    SdkLog.e("The authentication session has been canceled by user.")
                    completion(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    return
                } else {
                    SdkLog.e("An unknown authentication session error occurred.")
                    completion(SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    return
                }
            }
            
            SdkLog.d("callback url: \(callbackUrl)")
            
            let parseResult = callbackUrl.ageOauthResult()
            SdkLog.d("parseResult: \(String(describing: parseResult))")
            completion(parseResult)
            return
        }
        
        var parameters = [String:Any]()
        parameters["token_type"] = "api"
        
        if let accessToken = AUTH.tokenManager.getToken()?.accessToken {
            parameters["access_token"] = accessToken
        }
        parameters["return_url"] = "\(try! KakaoSDK.shared.scheme())://ageauth"
        
        if let authLevel = authLevel {
            parameters["auth_level"] = authLevel.parameterValue
        }
        
        parameters["auth_from"] = try! KakaoSDK.shared.appKey()
        
        if let ageLimit = ageLimit {
            parameters["age_limit"] = ageLimit
        }
        
        if let skipTerms = skipTerms {
            parameters["skip_term"] = skipTerms
        }
        
        if let adultsOnly = adultsOnly {
            parameters["adults_only"] = adultsOnly
        }
        
        if let underAge = underAge {
            parameters["under_age"] = underAge
        }
        
        let url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:PartnerPaths.ageAuth), parameters:parameters)

        if let url = url {
            SdkLog.d("\n===================================================================================================")
            SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
            
            if #available(iOS 12.0, *) {
                let authenticationSession = ASWebAuthenticationSession.init(url: url,
                                                                             callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                             completionHandler:authenticationSessionCompletionHandler)
                if #available(iOS 13.0, *) {
                    authenticationSession.presentationContextProvider = AUTH_CONTROLLER.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                }
                AUTH_CONTROLLER.authenticationSession = authenticationSession
                (AUTH_CONTROLLER.authenticationSession as? ASWebAuthenticationSession)?.start()
            }
            else {
                AUTH_CONTROLLER.authenticationSession = SFAuthenticationSession.init(url: url,
                                                                          callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                          completionHandler:authenticationSessionCompletionHandler)
                (AUTH_CONTROLLER.authenticationSession as? SFAuthenticationSession)?.start()
            }
        }
    }
}

/// :nodoc:
extension URL {
    public func ageOauthResult() -> Error? {
        var parameters = [String: String]()
        if let queryItems = URLComponents(string: self.absoluteString)?.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        var status : Int = -9999
        if let statusString =  parameters["status"] {
            status = Int(statusString) ?? -9999
            
            if status == 0 {
                return nil
            }
        }
        
        return AgeAuthError(status: status)
    }
}

/// 연령인증 에러
public enum AgeAuthError : Error {
    case AgeAuthFailed(reason:AgeAuthFailureReason, errorMessage:String?)
}

/// 연령인증(실명/본인/성인 인증) 에러 종류 입니다.
public enum AgeAuthFailureReason : Int {
    /// 알수 없는 에러
    case Unknown = -9999
    
    /// 파라미터 형식이 잘못됨
    case BadParameters = -440
    
    /// 인증되지 않은 사용자일 경우
    case Unauthorized = -401
    
    /// 연령인증이 되지 않아서 연령인증이 필요한 상황
    /// (보통 사용자가 외부 연령인증 페이지까지 갔다가 잘못된 정보를 입력하거나 취소하는 경우 발생할 수 있음)
    case NotAuthorizedAge = -450
    
    /// 현재 앱의 연령제한보다 사용자의 연령이 낮은 경우
    /// 대부분 만 14세 이상이지만 앱의 제한연령보다는 낮은 나이로 인증받은 경우 계정 DB에 인증 정보는 저장되지만, 서비스 이용은 불가하다는 페이지가 노출됩니다.
    /// *만 14세 미만은 인증 자체가 불가하도록 막았으므로, 이 오류코드가 리턴되지 않음.
    case LowerAgeLimit = -451
    
    /// 이미 연령인증이 되었습니다.
    /// (2차인증이 완료되어 있는 상황에서, 1차인증을 시도했을 경우에도 발생)
    case AlreadyAgeAuthorized = -452
    
    /// 연령인증 횟수 초과
    case ExceedAgeCheckLimit = -453
    
    /// 이전에 인증했던 정보와 불일치 (생일)
    /// (기존 BIRTHDAY_MISMATCH 에서 수정됨)
    case AgeAuthResultMismatch = -480
    
    /// CI 정보가 불일치할 경우
    case CIResultMismatch = -481
    
    /// 기타 서버 에러
    case Error = -500
}

/// :nodoc:
extension AgeAuthError {
    public init(status : Int?, message:String? = nil) {
        switch status {
        case -440:
            self = .AgeAuthFailed(reason: .BadParameters, errorMessage: message ?? "client information is incompatible.")
        case -401:
            self = .AgeAuthFailed(reason: .Unauthorized, errorMessage: "user is unauthenticated.")
        case -450:
            self = .AgeAuthFailed(reason: .NotAuthorizedAge, errorMessage:message ?? "age verification is required but not completed. (Normal situation to proceed age verification")
        case -451:
            self = .AgeAuthFailed(reason: .LowerAgeLimit, errorMessage: "user is younger than age limit specified in current app.")
        case -452:
            self = .AgeAuthFailed(reason: .AlreadyAgeAuthorized, errorMessage:message ?? "age verification has already been completed. (Even after completing 2-step verification,  user attempts 1-step verification.")
        case -453:
            self = .AgeAuthFailed(reason: .ExceedAgeCheckLimit, errorMessage: message ?? "user has exceeded the maximum number of failed attempts at age verification.")
        case -480:
            self = .AgeAuthFailed(reason: .AgeAuthResultMismatch, errorMessage: message ?? "does not match with the previously authenticated information(birthday). (replaced from BIRTHDAY_MISMATCH)")
        case -481:
            self = .AgeAuthFailed(reason: .CIResultMismatch, errorMessage:message ?? "CI information does not match.")
        case -500:
            self = .AgeAuthFailed(reason: .Error, errorMessage:message ?? "failed to find user, birthday does not match with the birthday received from CA, or unexpected error occurs.")
        default:
            self = .AgeAuthFailed(reason: .Unknown, errorMessage: message ?? "unknown error.")
        }
    }
}
