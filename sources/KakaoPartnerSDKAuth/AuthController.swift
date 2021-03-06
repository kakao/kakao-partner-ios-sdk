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

let AUTH_CONTROLLER = AuthController.shared

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

/// ???????????? ??????
public enum AgeAuthError : Error {
    case AgeAuthFailed(reason:AgeAuthFailureReason, errorMessage:String?)
}

/// ????????????(??????/??????/?????? ??????) ?????? ?????? ?????????.
public enum AgeAuthFailureReason : Int {
    /// ?????? ?????? ??????
    case Unknown = -9999
    
    /// ???????????? ????????? ?????????
    case BadParameters = -440
    
    /// ???????????? ?????? ???????????? ??????
    case Unauthorized = -401
    
    /// ??????????????? ?????? ????????? ??????????????? ????????? ??????
    /// (?????? ???????????? ?????? ???????????? ??????????????? ????????? ????????? ????????? ??????????????? ???????????? ?????? ????????? ??? ??????)
    case NotAuthorizedAge = -450
    
    /// ?????? ?????? ?????????????????? ???????????? ????????? ?????? ??????
    /// ????????? ??? 14??? ??????????????? ?????? ????????????????????? ?????? ????????? ???????????? ?????? ?????? DB??? ?????? ????????? ???????????????, ????????? ????????? ??????????????? ???????????? ???????????????.
    /// *??? 14??? ????????? ?????? ????????? ??????????????? ???????????????, ??? ??????????????? ???????????? ??????.
    case LowerAgeLimit = -451
    
    /// ?????? ??????????????? ???????????????.
    /// (2???????????? ???????????? ?????? ????????????, 1???????????? ???????????? ???????????? ??????)
    case AlreadyAgeAuthorized = -452
    
    /// ???????????? ?????? ??????
    case ExceedAgeCheckLimit = -453
    
    /// ????????? ???????????? ????????? ????????? (??????)
    /// (?????? BIRTHDAY_MISMATCH ?????? ?????????)
    case AgeAuthResultMismatch = -480
    
    /// CI ????????? ???????????? ??????
    case CIResultMismatch = -481
    
    /// ?????? ?????? ??????
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
