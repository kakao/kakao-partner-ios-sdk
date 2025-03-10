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
import KakaoSDKUser

/// 사용자 정보 가져오기 응답 \
/// Response for Retrieve user information
public struct PartnerUser : Codable {
    
    /// 회원번호 \
    /// Service user ID
    public let id: Int64?
    
    /// 사용자 프로퍼티 \
    /// User properties
    public let properties: [String:String]?
    
    /// 카카오계정 정보 \
    /// Kakao Account information
    /// ## SeeAlso
    /// - ``PartnerAccount``
    public let kakaoAccount: PartnerAccount?
    
    /// 그룹에서 맵핑 정보로 사용할 수 있는 값 \
    /// Token to map users in the group apps
    public let groupUserToken: String?
    
    /// 서비스에 연결 완료된 시각, UTC \
    /// Time connected to the service, UTC
    public let connectedAt : Date?
    
    /// 카카오싱크 간편가입을 통해 로그인한 시각, UTC \
    /// Time logged in through Kakao Sync Simple Signup, UTC
    public let synchedAt : Date?
    
    // for partner 전용
    /// 연결하기 호출의 완료 여부 \
    /// Whether the user is completely linked with the app
    public let hasSignedUp: Bool?
    
    /// 카카오 및 공동체, 제휴 앱에만 제공되는 추가 정보 \
    /// Additional user information for Kakao and partners
    /// ## SeeAlso 
    /// - ``ForPartner``
    public let forPartner: ForPartner?
}

/// 카카오 및 공동체, 제휴 앱에만 제공되는 카카오계정 추가 정보 \
/// Additional Kakao Account information for Kakao and partners
public struct PartnerAccount : Codable {
    
    // MARK: Fields
    
    /// 사용자 동의 시 프로필 제공 가능 여부 \
    /// Whether ``profile`` can be provided under user consent
    public let profileNeedsAgreement: Bool?
    /// 사용자 동의 시 닉네임 제공 가능 여부 \
    /// Whether ``profileNickname`` can be provided under user consent
    public let profileNicknameNeedsAgreement: Bool?
    /// 사용자 동의 시 프로필 사진 제공 가능 여부 \
    /// Whether ``profileImage`` can be provided under user consent
    public let profileImageNeedsAgreement: Bool?
    
    /// 프로필 정보 \
    /// Profile information
    /// ## SeeAlso 
    /// - [`Profile`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/profile)
    public let profile: Profile?
    
    /// 사용자 동의 시 이름 제공 가능 여부 \
    /// Whether ``name`` can be provided under user consent
    public let nameNeedsAgreement: Bool?
    /// 카카오계정 이름 \
    /// Name of Kakao Account
    public let name: String?
    
    /// 사용자 동의 시 카카오계정 대표 이메일 제공 가능 여부 \
    /// Whether ``email`` can be provided under user consent
    public let emailNeedsAgreement: Bool?
    /// 이메일 유효 여부 \
    /// Whether email address is valid
    public let isEmailValid: Bool?
    /// 이메일 인증 여부 \
    /// Whether email address is verified
    public let isEmailVerified: Bool?
    /// 카카오계정 대표 이메일 \
    /// Representative email of Kakao Account
    public let email: String?
    
    /// 사용자 동의 시 연령대 제공 가능 여부 \
    /// Whether ``ageRange``  can be provided under user consent
    public let ageRangeNeedsAgreement: Bool?
    /// 연령대 \
    /// Age range
    /// ## SeeAlso 
    /// - [`AgeRange`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/agerange)
    public let ageRange: AgeRange?
    
    /// 사용자 동의 시 출생 연도 제공 가능 여부 \
    /// Whether ``birthyear``  can be provided under user consent
    public let birthyearNeedsAgreement: Bool?
    /// 출생 연도, YYYY 형식 \
    /// Birthyear in YYYY format
    public let birthyear: String?
    
    /// 사용자 동의 시 생일 제공 가능 여부 \
    /// Whether ``birthday`` can be provided under user consent
    public let birthdayNeedsAgreement: Bool?
    /// 생일, MMDD 형식 \
    /// Birthday in MMDD format
    public let birthday: String?
    /// 생일 타입 \
    /// Birthday type
    /// ## SeeAlso
    /// - [`BirthdayType`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/birthdaytype)
    public let birthdayType: BirthdayType?
    /// 생일의 윤달 여부\
    /// Whether the birthday falls on a leap month
    public let isLeapMonth: Bool?
    
    /// 사용자 동의 시 전화번호 제공 가능 여부 \
    /// Whether ``gender`` can be provided under user consent
    public let genderNeedsAgreement: Bool?
    /// 성별 \
    /// Gender
    /// ## SeeAlso 
    /// - [`Gender`](https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKUser/documentation/kakaosdkuser/birthdaytype/rawrepresentable-implementations)
    public let gender: Gender?
    
    /// 사용자 동의 시 전화번호 제공 가능 여부 \
    /// Whether ``phoneNumber`` can be provided under user consent
    public let phoneNumberNeedsAgreement: Bool?
    /// 카카오계정의 전화번호 \
    /// Phone number of Kakao Account
    public let phoneNumber: String?
    
    /// 사용자 동의 시 실명 제공 가능 여부 \
    /// Whether ``legalName`` can be provided under user consent
    public let legalNameNeedsAgreement : Bool?
    /// 실명 \
    /// Legal name
    public let legalName : String?
    
    /// 사용자 동의 시 법정 생년월일 제공 가능 여부 \
    /// Whether ``isKorean`` can be provided under user consent
    public let legalBirthDateNeedsAgreement : Bool?
    /// 법정 생년월일, yyyyMMDD 형식 \
    /// Legal birth date in yyyyMMDD format
    public let legalBirthDate : String?
    
    /// 사용자 동의 시 법정 성별 제공 가능 여부 \
    /// Whether ``legalGender`` can be provided under user consent
    public let legalGenderNeedsAgreement : Bool?
    /// 법정 성별 \
    /// Legal gender
    public let legalGender : Gender?
    
    /// 사용자 동의 시 내외국인 제공 가능 여부 \
    /// Whther ``isKorean`` can be provided under user consent
    public let isKoreanNeedsAgreement : Bool?
    /// 본인인증을 거친 내국인 여부 \
    /// Whether the user is Korean
    public let isKorean : Bool?
    
    /// 사용자 동의 시 카카오계정 가입일자 제공 가능 여부 \
    /// Whether ``accountCreationDate`` can be provided under user consent
    public let accountCreationDateNeedsAgreement : Bool?
    /// 카카오계정 가입일자 \
    /// Kakao Account creation date
    public let accountCreationDate : String?

    // for partner 전용
    /// 카카오계정 통합 여부 \
    /// Whether the Kakao Account is unified
    public let unificationStatus : Bool?
    
    /// 카카오톡 가입 여부 \
    /// Whether the user is using Kakao Talk
    public let isKakaotalkUser: Bool?
    
    /// 카카오계정 대표 정보, 이메일 또는 전화번호 \
    /// Display ID, email or phone number
    public let displayId: String?
    
}

/// 카카오 및 공동체, 제휴 앱에만 제공되는 추가 정보 \
/// Additional user information for Kakao and partners
public struct ForPartner : Codable {
    
    /// 다른 사용자의 친구 정보에서 보여지는 해당 사용자의 고유 ID \
    /// Unique ID for the friend information
    public let uuid: String?
    
    /// 남은 일별 초대 메시지 전송 횟수 \
    /// Remaining invitation message count per day
    public let remainingInviteCount: Int?
    
    /// 남은 일별 그룹 메시지 전송 횟수 \
    /// Remaining group message count per day
    public let remainingGroupMsgCount: Int?
}

