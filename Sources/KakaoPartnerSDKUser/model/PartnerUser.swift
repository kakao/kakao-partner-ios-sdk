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

/// 사용자 정보 조회 API 응답으로 제공되는 사용자 정보 최상위 클래스입니다. 보다 자세한 내용은 Open SDK 용 User 문서를 참고해주세요.
public struct PartnerUser : Codable {
    
    public let id: Int64?
    public let properties: [String:String]?
    /// 카카오계정 정보
    /// - seealso: `PartnerAccount`
    public let kakaoAccount: PartnerAccount?
    public let groupUserToken: String?
    
    public let connectedAt : Date?
    public let synchedAt : Date?
    
    //for partner 전용.
    /// 사용자가 앱에 연결되어 있는지 여부를 나타냅니다. **자동 연결** 설정이 활성화되어 있는 경우 값이 내려오지 않으므로 앱에 연결되어 있다고 가정해도 무방합니다.
    public let hasSignedUp: Bool?
    /// 파트너용 사용자 정보
    /// - seealso: `ForPartner`
    public let forPartner: ForPartner?
}

///카카오계정에 등록된 사용자 개인정보를 제공합니다. (파트너 전용)
public struct PartnerAccount : Codable {
    
    // MARK: Fields
    
    /// profile 제공에 대한 사용자 동의 필요 여부
    public let profileNeedsAgreement: Bool?
    /// profile 닉네임 제공에 대한 사용자 동의 필요 여부
    public let profileNicknameNeedsAgreement: Bool?
    /// profile 이미지 제공에 대한 사용자 동의 필요 여부
    public let profileImageNeedsAgreement: Bool?
    
    /// 카카오계정에 등록한 프로필 정보
    /// - seealso: `Profile`
    public let profile: Profile?
    
    /// 카카오계정 이름에 대한 사용자 동의 필요 여부
    public let nameNeedsAgreement: Bool?
    /// 카카오계정 이름
    public let name: String?
    
    /// email 제공에 대한 사용자 동의 필요 여부
    public let emailNeedsAgreement: Bool?
    /// 카카오계정에 등록된 이메일의 유효성
    public let isEmailValid: Bool?
    /// 카카오계정에 이메일 등록 시 이메일 인증을 받았는지 여부
    public let isEmailVerified: Bool?
    /// 카카오계정에 등록된 이메일
    public let email: String?
    
    /// ageRange 제공에 대한 사용자 동의 필요 여부
    public let ageRangeNeedsAgreement: Bool?
    /// 연령대
    /// - seealso: `AgeRange`
    public let ageRange: AgeRange?
    /// birthyear 제공에 대한 사용자 동의 필요 여부
    public let birthyearNeedsAgreement: Bool?
    /// 출생 연도 (YYYY)
    public let birthyear: String?
    /// birthday 제공에 대한 사용자 동의 필요 여부
    public let birthdayNeedsAgreement: Bool?
    /// 생일 (MMDD)
    public let birthday: String?
    /// 생일의 양력/음력
    public let birthdayType: BirthdayType?
    
    /// gender 제공에 대한 사용자의 동의 필요 여부
    public let genderNeedsAgreement: Bool?
    /// 성별
    /// - seealso: `Gender`
    public let gender: Gender?
    
    /// phoneNumber 제공에 대한 사용자 동의 필요 여부
    public let phoneNumberNeedsAgreement: Bool?
    /// 카카오톡에서 인증한 전화번호
    public let phoneNumber: String?
    
    /// ci 제공에 대한 사용자의 동의 필요 여부
    public let ciNeedsAgreement: Bool?
    /// 암호화된 사용자 확인값
    public let ci: String?
    /// ci 발급시간
    public let ciAuthenticatedAt: Date?
    
    /// legalName 제공에 대한 사용자 동의 필요 여부
    public let legalNameNeedsAgreement : Bool?
    /// 실명
    public let legalName : String?
    
    /// legalBirthDate 제공에 대한 사용자 동의 필요 여부
    public let legalBirthDateNeedsAgreement : Bool?
    /// 법정생년월일
    public let legalBirthDate : String?
    
    /// legalGender 제공에 대한 사용자 동의 필요 여부
    public let legalGenderNeedsAgreement : Bool?
    /// 법정성별
    public let legalGender : Gender?
    
    ///한국인 여부 제공에 대한 사용자 동의 필요 여부
    public let isKoreanNeedsAgreement : Bool?
    ///한국인 여부
    public let isKorean : Bool?
    
    /// 카카오 계정 가입 일자 제공에 대한 사용자 동의 필요 여부
    public let accountCreationDateNeedsAgreement : Bool?
    
    /// 카카오 계정 가입 일자
    public let accountCreationDate : String?

    //for partner 전용.
    
    ///레거시 회원번호
    public let serviceUserId : Int64?
    
    ///통합계정 여부
    public let unificationStatus : Bool?
    
    /// 카카오톡 사용자인지 여부를 나타냅니다.
    public let isKakaotalkUser: Bool?
    /// 화면에 표시하기 위해 마스킹처리된 카카오계정의 이메일 또는 전화번호 값입니다.
    public let displayId: String?
    
}

/// 파트너용으로 제공되는 추가 정보입니다.
public struct ForPartner : Codable {
    
    /// 메시지를 전송하기 위한 고유 아이디
    ///
    /// 카카오 서비스의 회원임을 앱내에서 식별 할 수 있지만, 사용자의 계정 상태에 따라 이 정보는 바뀔 수 있습니다. 앱내의 사용자 식별자로 저장 사용되는 것은 권장하지 않습니다.
    public let uuid: String?
    
    /// 남아 있는 초대 메시지 전송 가능 횟수
    public let remainingInviteCount: Int?
    
    /// 남아있는 그룹 메시지 전송 가능 횟수
    public let remainingGroupMsgCount: Int?
}

