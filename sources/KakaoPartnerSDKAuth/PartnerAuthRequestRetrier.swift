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
import KakaoSDKCommon
import KakaoSDKAuth

public class PartnerAuthRequestRetrier : RequestInterceptor {
        
    private var errorLock = NSLock()
    
    private func getSdkError(error: Error) -> SdkError? {
        if let aferror = error as? AFError {
            switch aferror {
            case .responseValidationFailed(let reason):
                switch reason {
                case .customValidationFailed(let error):
                    return error as? SdkError
                default:
                    SdkLog.d("not customValidationFailed. - dont care case")
                }
            default:
                SdkLog.d("not responseValidationFailed. - dont care case")
                
            }
        }
        return nil
    }
    
    public init() {
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        errorLock.lock() ; defer { errorLock.unlock() }
        
        var logString = "partner request retrier:"

        if let sdkError = getSdkError(error: error) {
            if !sdkError.isApiFailed {
                SdkLog.e("\(logString)\n error:\(error)\n not api error -> pass through\n\n")
                completion(.doNotRetryWithError(SdkError(message:"not api error -> pass through")))
                return
            }

            switch(sdkError.getApiError().reason) {
            case .RequiredAgeVerification:
                logString = "\(logString)\n reason:\(error)\n token: \(String(describing: AUTH.tokenManager.getToken()))"
                SdkLog.e("\(logString)\n\n")                

                DispatchQueue.main.async {
                    AuthController.shared.verifyAgeWithAuthenticationSession() { (error) in
                        if let error = error {
                            completion(.doNotRetryWithError(error))
                        }
                        else {
                            completion(.retry)
                        }
                    }
                }
            case .UnderAgeLimit:
                completion(.doNotRetryWithError(error))
            default:
                SdkLog.e("\(sdkError)\n not handled error -> pass through \n\n")
                completion(.doNotRetry)
            }
        }
        else {
            SdkLog.e("\(error)\n no  not handled error -> pass through \n\n")
            completion(.doNotRetry)
        }
    }
}
