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
import KakaoSDKCommon

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension ApprovalType {
    public convenience init(type:String) {
        self.init()
        self.type = type
    }
}

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
extension SdkIdentifier {        
    public convenience init(infos customInfos:[String:String]? = nil) {
        var tempIdentifier : String? = nil
        if let customInfos = customInfos {
            customInfos.keys.forEach { key in
                tempIdentifier = tempIdentifier != nil ? "\(tempIdentifier!) \(key)/\(customInfos[key]!)" : "\(key)/\(customInfos[key]!)"
            }
            self.init(tempIdentifier)
            SdkLog.d("customIdentifier: \(customIdentifier!)")
        }
        else {
            self.init(nil)
        }
    }
}

