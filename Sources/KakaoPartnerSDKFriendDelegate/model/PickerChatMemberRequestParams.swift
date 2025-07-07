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
#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@_exported import KakaoSDKFriendCore

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
public struct PickerChatMemberRequestParams {
    public let viewAppearance: ViewAppearance?
    public let orientation: PickerOrientation?
    public let enableSearch: Bool?
    public let disableSelectOptions: [DisableSelectOption]?
    public let displayAllProfile: Bool?
    public var maxPickableCount: Int?
    public var minPickableCount: Int?
    
    public init(
        viewAppearance: ViewAppearance? = nil,
        orientation: PickerOrientation? = nil,
        enableSearch: Bool? = nil,
        disableSelectOptions: [DisableSelectOption]? = nil,
        displayAllProfile: Bool? = nil,
        maxPickableCount: Int? = nil,
        minPickableCount: Int? = nil
    ) {
        self.viewAppearance = viewAppearance
        self.orientation = orientation
        self.enableSearch = enableSearch
        self.disableSelectOptions = disableSelectOptions
        self.displayAllProfile = displayAllProfile
        self.maxPickableCount = maxPickableCount ?? 30
        self.minPickableCount = minPickableCount ?? 1
    }
    
    internal func toFriendRequestParams() -> PickerFriendRequestParams {
        PickerFriendRequestParams(
            title: nil,
            friendFilter: nil,
            countryCodeFilters: nil,
            usingOsFilter: nil,
            viewAppearance: viewAppearance,
            orientation: orientation,
            enableSearch: enableSearch,
            enableIndex: false,
            showMyProfile: false,
            showFavorite: false,
            disableSelectOptions: disableSelectOptions,
            displayAllProfile: displayAllProfile,
            maxPickableCount: maxPickableCount,
            minPickableCount: minPickableCount
        )
    }
}
