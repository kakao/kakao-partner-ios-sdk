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

/// 카카오톡 공유 호출을 담당하는 클래스입니다.
extension ShareApi {
    
    @_documentation(visibility: private)
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
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// 원하는 앱의 네이티브 앱 키를 "targetAppKey"로 전달해 말풍선 출처 영역에 출력할 앱 정보를 지정할 수 있습니다.
    /// ## SeeAlso 
    /// - ``Templatable``
    /// - ``SharingResult``
    public func shareDefault(targetAppKey:String,
                            templatable: Templatable,
                            serverCallbackArgs:[String:String]? = nil,
                            completion:@escaping (SharingResult?, Error?) -> Void) {
        
        self.shareDefault( targetAppKey:targetAppKey,
                          templateObjectJsonString: templatable.toJsonObject()?.toJsonString(),
                          serverCallbackArgs:serverCallbackArgs,
                          completion: completion)
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// 원하는 앱의 네이티브 앱 키를 "targetAppKey"로 전달해 말풍선 출처 영역에 출력할 앱 정보를 지정할 수 있습니다.
    /// ## SeeAlso 
    /// - ``SharingResult``
    public func shareDefault(targetAppKey:String,
                            templateObject:[String:Any],
                            serverCallbackArgs:[String:String]? = nil,
                            completion:@escaping (SharingResult?, Error?) -> Void ) {
        
        self.shareDefault(targetAppKey:targetAppKey,
                         templateObjectJsonString: templateObject.toJsonString(),
                         serverCallbackArgs:serverCallbackArgs,
                         completion: completion)
    }
    
    /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오톡으로 공유합니다.
    /// 원하는 앱의 네이티브 앱 키를 "targetAppKey"로 전달해 말풍선 출처 영역에 출력할 앱 정보를 지정할 수 있습니다.
    /// ## SeeAlso 
    /// - ``SharingResult``
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
    
    /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡으로 공유합니다. 템플릿을 생성하는 방법은 [https://developers.kakao.com/docs/latest/ko/message/ios#create-message](https://developers.kakao.com/docs/latest/ko/message/ios#create-message) 을 참고하시기 바랍니다.
    /// 원하는 앱의 네이티브 앱 키를 "targetAppKey"로 전달해 말풍선 출처 영역에 출력할 앱 정보를 지정할 수 있습니다.
    /// ## SeeAlso 
    /// - ``SharingResult``
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
