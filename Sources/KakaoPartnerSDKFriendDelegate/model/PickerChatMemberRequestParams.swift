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
@_documentation(visibility: private)
@_exported import KakaoSDKFriendCore

@_documentation(visibility: private)
public struct PickerChatMemberRequestParams {
    public let viewAppearance: ViewAppearance
    public let orientation: PickerOrientation
    public let enableSearch: Bool
    public let disableSelectOptions: [DisableSelectOption]?
    public let displayAllProfile: Bool
    public let selectParams: SelectParams

    public init(
        viewAppearance: ViewAppearance = .auto,
        orientation: PickerOrientation = .auto,
        enableSearch: Bool = true,
        disableSelectOptions: [DisableSelectOption]? = nil,
        displayAllProfile: Bool = false,
        selectParams: SelectParams
    ) {
        self.viewAppearance = viewAppearance
        self.orientation = orientation
        self.enableSearch = enableSearch
        self.disableSelectOptions = disableSelectOptions
        self.displayAllProfile = displayAllProfile
        self.selectParams = selectParams
    }
    
    internal func toFriendRequestParams() -> PickerFriendRequestParams {
        PickerFriendRequestParams(
            friendFilter: .none,
            countryCodeFilters: nil,
            usingOsFilter: .all,
            viewAppearance: viewAppearance,
            orientation: orientation,
            enableSearch: enableSearch,
            enableIndex: false,
            showMyProfile: false,
            showFavorite: false,
            disableSelectOptions: disableSelectOptions,
            displayAllProfile: displayAllProfile,
            selectParams: selectParams
        )
    }
}
