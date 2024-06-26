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

/// 메시지 전송 결과 \
/// Sending message result
/// ## SeeAlso
/// - ``TalkApi/sendDefaultMessage(templatable:receiverUuids:)``
/// - ``TalkApi/sendScrapMessage(requestUrl:templateId:templateArgs:receiverUuids:)``
/// - ``TalkApi/sendCustomMessage(templateId:templateArgs:receiverUuids:)``
public struct PartnerMessageSendResult : Codable {
    
    // MARK: Fields
    
    /// 메시지 전송에 성공한 수신자 ID 목록 \
    /// Reciever IDs that succeeded in sending the message
    public let successfulReceiverIds: [String]?
    
    /// 메시지 전송 실패 정보 \
    /// Failure information for sending a message
    public let failureInfos: [PartnerMessageFailureInfo]?
    
    
    // MARK: Internal
    
    enum CodingKeys: String, CodingKey {
        case successfulReceiverIds
        case failureInfos = "failureInfo"
    }
}

/// 메시지 전송 실패 정보 \
/// Failure information for sending a message
/// ## SeeAlso 
/// - ``MessageSendResult/failureInfos``
public struct PartnerMessageFailureInfo : Codable {
    
    // MARK: Fields
    
    /// 에러 코드 \
    /// Error code
    public let code: Int
    
    /// 에러 메시지 \
    /// Error message
    public let msg: String
    
    /// 메시지 전송에 실패한 수신자 UUID 목록 \
    /// Reciever UUIDs that failed to send the message
    public let receiverIds: [String]
}
