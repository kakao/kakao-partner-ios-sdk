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

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@available(iOSApplicationExtension, unavailable)
public let PARTNER_AUTH_API = PartnerAuthCommon.shared

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@available(iOSApplicationExtension, unavailable)
public class PartnerAuthCommon {
    
    static public let shared = PartnerAuthCommon()
    
    public init() {
        AUTH.checkMigration()
        initSession()
    }
    
    public func initSession() {
        let interceptor = Interceptor(adapters: [AuthRequestAdapter()], retriers: [AuthRequestRetrier(), PartnerAuthRequestRetrier()])
        
        let sessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.tlsMinimumSupportedProtocolVersion = .TLSv12
        API.addSession(type: .PartnerAuthApi, session: Session(configuration: sessionConfiguration, interceptor: interceptor ))
    }
    
    public func responseData(_ kHTTPMethod: KHTTPMethod,
                             _ url: String,
                             parameters: [String: Any]? = nil,
                             headers: [String: String]? = nil,
                             apiType: ApiType,
                             completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        
        API.responseData(kHTTPMethod, url, parameters: parameters, headers: headers, sessionType: .PartnerAuthApi, apiType: apiType, completion: completion)
    }
}
