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
import KakaoSDKShare
import KakaoSDKTemplate

/// [카카오톡 공유](https://developers.kakao.com/docs/latest/ko/message/common) API 클래스 \
/// Class for the [Kakao Talk Sharing](https://developers.kakao.com/docs/latest/ko/message/common) APIs
extension ShareApi {
    /// 기본 템플릿으로 메시지 보내기 \
    /// Send message with default template
    /// - parameters:
    ///   - targetAppKey: 출처 영역에 보여질 서비스 앱의 네이티브 키 \
    ///                   Native app key of the service app displayed on the source area
    ///   - templateObjectJsonString: 기본 템플릿 객체를 JSON 형식으로 변환한 문자열 \
    ///                               String converted in JSON format from a default template
    ///   - serverCallbackArgs: 카카오톡 공유 전송 성공 알림에 포함할 키와 값 \
    ///                         Keys and values for the Kakao Talk Sharing success callback
    /// ## SeeAlso
    /// - [`SharingResult`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKShare/documentation/kakaosdkshare/sharingresult)
    func shareDefault(targetAppKey:String,
                     templateObjectJsonString:String? = nil,
                     serverCallbackArgs:[String:String]? = nil,
                     completion:@escaping (SharingResult?, Error?) -> Void ) {
        return API.responseData(.post,
                                Urls.compose(path:Paths.shareDefalutValidate),
                                parameters: ["link_ver":"4.0",
                                             "template_object":templateObjectJsonString,
                                             "target_app_key":targetAppKey].filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api,
                                apiType: .KApi) { [unowned self] (response, data, error) in
                                if let error = error {
                                    completion(nil, error)
                                }
                                else {
                                    self.transformResponseToSharingResult(response: response, data: data, targetAppKey:targetAppKey, serverCallbackArgs: serverCallbackArgs) { (sharingResult, error) in
                                        if let error = error {
                                            completion(nil, error)
                                        }
                                        else {
                                            if let sharingResult = sharingResult {
                                                completion(sharingResult, nil)
                                            }
                                            else {
                                                completion(nil, SdkError(reason:.Unknown, message: "sharingResult is nil"))
                                            }
                                        }
                                    }
                                }
        }
    }
    
    /// 기본 템플릿으로 메시지 보내기 \
    /// Send message with default template
    /// - parameters:
    ///   - targetAppKey: 출처 영역에 보여질 서비스 앱의 네이티브 키 \
    ///                   Native app key of the service app displayed on the source area
    ///   - templatable: 기본 템플릿으로 변환 가능한 객체 \
    ///                  Object to convert to a default template
    ///   - serverCallbackArgs: 카카오톡 공유 전송 성공 알림에 포함할 키와 값 \
    ///                         Keys and values for the Kakao Talk Sharing success callback
    /// ## SeeAlso 
    /// - [`Templatable`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKTemplate/documentation/kakaosdktemplate/templatable)
    /// - [`SharingResult`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKShare/documentation/kakaosdkshare/sharingresult)
    public func shareDefault(targetAppKey:String,
                            templatable: Templatable,
                            serverCallbackArgs:[String:String]? = nil,
                            completion:@escaping (SharingResult?, Error?) -> Void) {
        
        self.shareDefault( targetAppKey:targetAppKey,
                          templateObjectJsonString: templatable.toJsonObject()?.toJsonString(),
                          serverCallbackArgs:serverCallbackArgs,
                          completion: completion)
    }
    
    /// 기본 템플릿으로 메시지 보내기 \
    /// Send message with default template
    /// - parameters:
    ///   - targetAppKey: 출처 영역에 보여질 서비스 앱의 네이티브 키 \
    ///                   Native app key of the service app displayed on the source area
    ///   - templateObject: 기본 템플릿 객체 \
    ///                     Default template object
    ///   - serverCallbackArgs: 카카오톡 공유 전송 성공 알림에 포함할 키와 값 \
    ///                         Keys and values for the Kakao Talk Sharing success callback
    /// ## SeeAlso 
    /// -  [`SharingResult`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKShare/documentation/kakaosdkshare/sharingresult)
    public func shareDefault(targetAppKey:String,
                            templateObject:[String:Any],
                            serverCallbackArgs:[String:String]? = nil,
                            completion:@escaping (SharingResult?, Error?) -> Void ) {
        
        self.shareDefault(targetAppKey:targetAppKey,
                         templateObjectJsonString: templateObject.toJsonString(),
                         serverCallbackArgs:serverCallbackArgs,
                         completion: completion)
    }
    
    /// 스크랩 메시지 보내기 \
    /// Send scrape message
    /// - parameters:
    ///   - targetAppKey: 출처 영역에 보여질 서비스 앱의 네이티브 키 \
    ///                   Native app key of the service app displayed on the source area
    ///   - requestUrl: 스크랩할 URL \
    ///                 URL to scrape
    ///   - templateId: 사용자 정의 템플릿 ID \
    ///                 Custom template ID
    ///   - templateArgs: 사용자 인자 키와 값 \
    ///                   Keys and values of the user argument
    ///   - serverCallbackArgs: 카카오톡 공유 전송 성공 알림에 포함할 키와 값 \
    ///                         Keys and values for the Kakao Talk Sharing success callback
    /// ## SeeAlso
    /// - [`SharingResult`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKShare/documentation/kakaosdkshare/sharingresult)
    public func shareScrap(targetAppKey:String,
                          requestUrl:String,
                          templateId:Int64? = nil,
                          templateArgs:[String:String]? = nil,
                          serverCallbackArgs:[String:String]? = nil,
                          completion:@escaping (SharingResult?, Error?) -> Void ) {
        return API.responseData(.post,
                                Urls.compose(path:Paths.shareScrapValidate),
                                parameters: ["link_ver":"4.0",
                                             "request_url":requestUrl,
                                             "template_id":templateId,
                                             "target_app_key":targetAppKey,
                                             "template_args":templateArgs?.toJsonString()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api,
                                apiType: .KApi) { [unowned self] (response, data, error) in
                                if let error = error {
                                    completion(nil, error)
                                }
                                else {
                                    self.transformResponseToSharingResult(response: response, data: data, targetAppKey:targetAppKey, serverCallbackArgs: serverCallbackArgs) { (sharingResult, error) in
                                        if let error = error {
                                            completion(nil, error)
                                        }
                                        else {
                                            if let sharingResult = sharingResult {
                                                completion(sharingResult, nil)
                                            }
                                            else {
                                                completion(nil, SdkError(reason:.Unknown, message: "sharingResult is nil"))
                                            }
                                        }
                                    }
                                }
        }
    }
    
    /// 사용자 정의 템플릿으로 메시지 보내기 \
    /// Send message with custom template
    /// - parameters:
    ///   - targetAppKey: 출처 영역에 보여질 서비스 앱의 네이티브 키 \
    ///                   Native app key of the service app displayed on the source area
    ///   - templateId: 사용자 정의 템플릿 ID \
    ///                 Custom template ID
    ///   - templateArgs: 사용자 인자 키와 값 \
    ///                   Keys and values of the user argument
    ///   - serverCallbackArgs: 카카오톡 공유 전송 성공 알림에 포함할 키와 값 \
    ///                         Keys and values for the Kakao Talk Sharing success callback
    /// ## SeeAlso 
    /// - [`SharingResult`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKShare/documentation/kakaosdkshare/sharingresult)
    public func shareCustom(targetAppKey:String,
                           templateId:Int64,
                           templateArgs:[String:String]? = nil,
                           serverCallbackArgs:[String:String]? = nil,
                           completion:@escaping (SharingResult?, Error?) -> Void ) {
        return API.responseData(.post,
                                Urls.compose(path:Paths.shareCustomValidate),
                                parameters: ["link_ver":"4.0",
                                             "template_id":templateId,
                                             "target_app_key":targetAppKey,
                                             "template_args":templateArgs?.toJsonString()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api,
                                apiType: .KApi ) { [unowned self] (response, data, error) in
                                if let error = error {
                                    completion(nil, error)
                                }
                                else {
                                    self.transformResponseToSharingResult(response: response, data: data, targetAppKey:targetAppKey, serverCallbackArgs: serverCallbackArgs) { (sharingResult, error) in
                                        if let error = error {
                                            completion(nil, error)
                                        }
                                        else {
                                            if let sharingResult = sharingResult {
                                                completion(sharingResult, nil)
                                            }
                                            else {
                                                completion(nil, SdkError(reason:.Unknown, message: "sharingResult is nil"))
                                            }
                                        }
                                    }
                                }
        }
    }
    
    
}
