//  Copyright 2025 Kakao Corp.
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

/// 에러 정보
public struct KFErrorInfo: Codable {
    /// 에러 코드 \
    /// Error code
    public let code: KFApiFailureReason
    
    /// 에러 메시지 \
    /// Error message
    public let msg: String
    
    /// 사용자가 동의해야 하는 동의항목 \
    /// Scopes that the user must agree to
    public let requiredScopes: [String]?
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    /// API 종류 \
    /// API type
    public let apiType: String?
    
    /// 사용자가 동의한 동의항목 \
    /// Scopes that the user agreed to
    public let allowedScopes: [String]?
    
    public init(code: KFApiFailureReason, msg:String, requiredScopes:[String]?) {
        self.code = code
        self.msg = msg
        self.requiredScopes = requiredScopes
        self.apiType = nil
        self.allowedScopes = nil
    }
}

public enum KFApiSdkError: Error {
    case ApiFailed(reason: KFApiFailureReason, errorInfo: KFErrorInfo?)
    
    public init?(response:HTTPURLResponse, data:Data) {
        if 200 ..< 300 ~= response.statusCode { return nil }
        
        if let errorInfo = try? KFJSONDecoder.custom.decode(KFErrorInfo.self, from: data) {
            self = .ApiFailed(reason: errorInfo.code, errorInfo: errorInfo)
        }
        else {
            return nil
        }
    }
}

public enum KFApiFailureReason: Int, Codable {
    // 알 수 없음 \
    /// Unknown
    case Unknown = -9999
    
    /// 서버 내부에서 처리 중 에러가 발생한 경우 \
    /// An Error occurred during the internal processing on the server
    case Internal = -1
    
    /// 필수 파라미터가 포함되지 않았거나, 파라미터 값이 올바르지 않은 경우 \
    /// Requested without required parameters or using invalid values
    case BadParameter = -2
    
    /// API 사용에 필요한 사전 설정을 완료하지 않은 경우 \
    /// Required prerequisites for the API are not completed
    case UnsupportedApi = -3
    
    /// 카카오계정이 제재되었거나, 카카오계정에 제한된 동작을 요청한 경우 \
    /// Requested by a blocked Kakao Account, or requested restricted actions to the Kakao Account
    case Blocked = -4
    
    /// 앱에 사용 권한이 없는 API를 호출한 경우 \
    /// Requested an API using an app that does not have permission
    case Permission = -5
    
    /// 제공 종료된 API를 호출한 경우 \
    /// Requested a deprecated API
    case DeprecatedApi = -9
    
    /// 사용량 제한을 초과한 경우 \
    /// Exceeded the quota
    case ApiLimitExceed = -10
    
    /// 앱과 연결되지 않은 사용자가 요청한 경우 \
    /// Requested by a user who is not linked to the app
    case NotSignedUpUser = -101
    
    /// 이미 앱과 연결되어 있는 사용자에 대해 연결하기 요청한 경우 \
    /// Requested manual sign-up to a linked user
    case AlreadySignedUpUsercase = -102
    
    /// 휴면 상태, 또는 존재하지 않는 카카오계정으로 요청한 경우 \
    /// Requested with a Kakao Account that is in the dormant state or does not exist
    case NotKakaoAccountUser = -103
    
    /// 앱에 추가하지 않은 사용자 프로퍼티 키 값을 불러오거나 저장하려고 한 경우 \
    /// Requested to retrieve or save value for not registered user properties key
    case InvalidUserPropertyKey = -201
    
    /// 등록되지 않은 앱 키로 요청했거나, 존재하지 않는 앱에 대해 요청한 경우 \
    /// Requested with an app key of not registered app, or requested to an app that does not exist
    case NoSuchApp = -301
    
    /// 유효하지 않은 앱 키나 액세스 토큰으로 요청했거나, 앱 정보가 등록된 앱 정보와 일치하지 않는 경우 \
    /// Requested with an invalid app key or an access token, or the app information is not equal to the registered app information
    case InvalidAccessToken = -401
    
    /// 접근하려는 리소스에 대해 사용자 동의를 받지 않은 경우 \
    /// The user has not agreed to the scope of the desired resource
    case InsufficientScope = -402
    
    /// 연령인증 필요 \
    /// Age verification is required
    case RequiredAgeVerification = -405
    
    /// 앱에 설정된 제한 연령보다 사용자의 연령이 낮음 \
    /// User's age does not meet the app's age limit
    case UnderAgeLimit = -406
    
    // papi error code=E2006
    /// 서명이 완료되지 않은 경우 \
    /// Signing is not completed
    case SigningIsNotCompleted = -421
    
    // papi error code=E2007
    /// 유효시간 안에 서명이 완료되지 않은 경우 \
    /// Signing is not completed in the valid time
    case InvalidTransaction = -422
    
    // papi error code=E2016
    /// 공개 키가 만료된 경우 \
    /// The public key has been expired
    case TransactionHasExpired = -423
    

    /// 14세 미만 미허용 설정이 되어 있는 앱으로 14세 미만 사용자가 API 호출한 경우 \
    /// Users under age 14 requested in the app that does not allow users under age 14
    case LowerAgeLimit = -451

    /// 이미 연령인증을 완료함 \
    /// Age verification is already completed
    case AlreadyAgeAuthorized = -452

    /// 연령인증 요청 제한 회수 초과 \
    /// Exceeded the limit of request for the age verification
    case AgeCheckLimitExceed = -453

    /// 기존 연령인증 결과와 일치하지 않음 \
    /// The result is not equal to the previous result of age verification
    case AgeResultMismatched = -480

    /// CI 불일치 \
    /// CI is mismatched
    case CIResultMismatched = -481
    
    /// 카카오톡 미가입 사용자가 카카오톡 API를 호출한 경우 \
    /// Users not signed up for Kakao Talk requested the Kakao Talk APIs
    case NotTalkUser = -501
    
    /// 지원되지 않는 기기로 메시지를 전송한 경우 \
    /// Sent message to an unsupported device
    case UserDevicedUnsupported = -504
    
    /// 받는 이가 프로필 비공개로 설정한 경우 \
    /// The receiver turned off the profile visibility
    case TalkMessageDisabled = -530
    
    /// 보내는 이가 한 달 동안 보낼 수 있는 쿼터를 초과한 경우 \
    /// The sender exceeded the monthly quota for sending messages
    case TalkSendMessageMonthlyLimitExceed = -531
    
    /// 보내는 이가 하루 동안 보낼 수 있는 쿼터를 초과한 경우 \
    /// The sender exceeded the daily quota for sending messages
    case TalkSendMessageDailyLimitExceed = -532
        
    /// 업로드 가능한 이미지 최대 용량을 초과한 경우 \
    /// Exceeded the maximum size of images to upload
    case ImageUploadSizeExceed = -602
    
    /// 카카오 플랫폼 내부에서 요청 처리 중 타임아웃이 발생한 경우 \
    /// Timeout occurred during the internal processing in the server
    case ServerTimeout = -603
    
    /// 업로드할 수 있는 최대 이미지 개수를 초과한 경우 \
    /// Exceeded the maximum number of images to upload
    case ImageMaxUploadNumberExceed = -606
    
    /// 서비스 점검 중 \
    /// Under the service maintenance
    case UnderMaintenance = -9798
}
