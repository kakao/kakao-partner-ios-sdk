//
//  TalkApi+Rx.swift
//  KakaoPartnerSDK
//
//  Created by apiteam on 5/9/2019.
//  Copyright © 2019 apiteam. All rights reserved.
//

import Foundation
import Alamofire

import KakaoPartnerSDKCommon
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKTalk
import KakaoSDKTemplate

/// 카카오톡 API 호출을 담당하는 클래스입니다.
extension TalkApi  {
        
    /// 수신자 아이디 타입 열거형
    public enum ReceiverIdType : String {
        /// Uuid
        case Uuid = "uuid"
        /// 유저 아이디
        case UserId = "user_id"
        /// 채팅방 아이디
        case ChatId = "chat_id"
    }
    
    /// 카카오톡 채팅방 목록을 가져옵니다.
    /// - seealso: `Chats`
    public func chatList(filters: [ChatFilter]? = nil,
                        offset: Int? = nil,
                        limit: Int? = nil,
                        order: Order? = nil,
                        completion:@escaping (Chats?, Error?) -> Void) {
        
                            AUTH.responseData(.get,
                                              Urls.compose(path:PartnerPaths.chatList),
                                              parameters:["filter": filters?.map({ $0.parameterValue }).joined(separator: ","),
                                                          "offset": offset,
                                                          "limit": limit,
                                                          "order": order?.rawValue].filterNil(),
                                              apiType: .KApi) { (response, data, error) in
                                                if let error = error {
                                                    completion(nil, error)
                                                    return
                                                }

                                                if let data = data {
                                                    completion(try? SdkJSONDecoder.custom.decode(Chats.self, from: data), nil)
                                                    return
                                                }

                                                completion(nil, SdkError())
                            }
    }
    
    /// 사용자의 카카오톡 채팅방에 속한 멤버를 조회합니다. 채팅방 아이디를 기준으로 조회하며 친구인 멤버만 조회할지 여부를 선택할 수 있습니다.
    /// - seealso: `ChatMembers`
    public func chatMembers(chatId:Int64,
                            friendsOnly:Bool,
                            includeProfile: Bool? = nil,
                            token: String? = nil,
                            completion:@escaping (ChatMembers?, Error?) -> Void) {
        
        AUTH.responseData(.get,
                          Urls.compose(path:PartnerPaths.chatMembers),
                          parameters: ["chat_id":chatId,
                                         "friends_only": friendsOnly,
                                         "include_profile": includeProfile,
                                         "token":token].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(ChatMembers.self, from: data), nil)
                                return
                            }

                            completion(nil, SdkError())
        }
    }
    
    /// 기본 템플릿을 사용하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다.
    public func sendDefaultMessageForPartner(templatable:Templatable,
                                             receiverIdType:ReceiverIdType,
                                             receiverIds:[Any],
                                             completion:@escaping (PartnerMessageSendResult?, Error?) -> Void) {
        
        let castedReceiverIds = receiverIds.map { (ids) -> String in "\(ids)" }
        
        AUTH.responseData(.post,
                          Urls.compose(path:PartnerPaths.defaultMessage),
                          parameters: ["receiver_id_type":receiverIdType.rawValue,
                                         "template_object":templatable.toJsonObject()?.toJsonString(),
                                         "receiver_ids":castedReceiverIds.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(PartnerMessageSendResult.self, from: data), nil)
                                return
                            }

                            completion(nil, SdkError())
        }
    }
    
    /// 개발자사이트에서 생성한 메시지 템플릿을 사용하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/template 을 참고하시기 바랍니다.
    public func sendCustomMessageForPartner(templateId: Int64,
                                            templateArgs:[String:Any]? = nil,
                                            receiverIdType:ReceiverIdType,
                                            receiverIds:[Any],
                                            completion:@escaping (PartnerMessageSendResult?, Error?) -> Void) {
        
        //포맷통일
        let castedReceiverIds = receiverIds.map { (ids) -> String in "\(ids)" }
        
        AUTH.responseData(.post,
                            Urls.compose(path:PartnerPaths.customMessage),
                            parameters: ["receiver_id_type":receiverIdType.rawValue,
                                           "receiver_ids":castedReceiverIds.toJsonString(),
                                           "template_id":templateId,
                                           "template_args":templateArgs?.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(PartnerMessageSendResult.self, from: data), nil)
                                return
                            }

                            completion(nil, SdkError())
        }
    }
    
    /// 지정된 URL을 스크랩하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다. 스크랩 커스텀 템플릿 가이드를 참고하여 템플릿을 직접 만들고 스크랩 메시지 전송에 이용할 수도 있습니다.
    public func sendScrapMessageForPartner(requestUrl: String,
                                           templateId: Int64? = nil,
                                           templateArgs:[String:Any]? = nil,
                                           receiverIdType:ReceiverIdType,
                                           receiverIds:[Any],
                                           completion:@escaping (PartnerMessageSendResult?, Error?) -> Void) {
        
        //포맷통일
        let castedReceiverIds = receiverIds.map { (ids) -> String in "\(ids)" }
        
        AUTH.responseData(.post,
                           Urls.compose(path:PartnerPaths.scrapMessage),
                           parameters: ["receiver_id_type":receiverIdType.rawValue,
                                          "receiver_ids":castedReceiverIds.toJsonString(),
                                          "request_url": requestUrl,
                                          "template_id":templateId,
                                          "template_args":templateArgs?.toJsonString()].filterNil(),
                            apiType: .KApi) { (response, data, error) in
                              if let error = error {
                                  completion(nil, error)
                                  return
                              }

                              if let data = data {
                                  completion(try? SdkJSONDecoder.custom.decode(PartnerMessageSendResult.self, from: data), nil)
                                  return
                              }

                              completion(nil, SdkError())
          }
    }
    
    /// 카카오톡 친구 목록을 조회합니다. Open SDK의 확장으로 앱에 가입되지 않은 친구도 조회할 수 있습니다.
    /// - seealso: `PartnerFriend`
    public func friendsForPartner(friendType: FriendType? = nil,
                                  friendFilter: FriendFilter? = nil,
                                  friendOrder: FriendOrder? = nil,
                                  offset: Int? = nil,
                                  limit: Int? = nil,
                                  order: Order? = nil,
                                  countryCodes: [String]? = nil,
                                  completion:@escaping (Friends<PartnerFriend>?, Error?) -> Void) {
        
        AUTH.responseData(.get,
                            Urls.compose(path:PartnerPaths.friends),
                            parameters: ["friend_type":friendType?.rawValue,
                                          "friend_filter":friendFilter?.rawValue,
                                          "friend_order": friendOrder?.rawValue,
                                          "offset":offset,
                                          "limit":limit,
                                          "order":order?.rawValue,
                                          "country_codes":countryCodes?.joined(separator:",")].filterNil(),
                            apiType: .KApi) { (response, data, error) in
                                  if let error = error {
                                      completion(nil, error)
                                      return
                                  }

                                  if let data = data {
                                      completion(try? SdkJSONDecoder.custom.decode(Friends<PartnerFriend>.self, from: data), nil)
                                      return
                                  }

                                  completion(nil, SdkError())
        }
    }
    
    /// 카카오톡 친구 목록을 FriendContext를 파라미터로 조회합니다. Open SDK의 확장으로 앱에 가입되지 않은 친구도 조회할 수 있습니다.
    /// - seealso: `PartnerFriendsContext`
    public func friendsForPartner(context: PartnerFriendsContext?,
                                  completion:@escaping (Friends<PartnerFriend>?, Error?) -> Void) {
        
        friendsForPartner(friendType: context?.friendType,
                          friendFilter: context?.friendFilter,
                          friendOrder: context?.friendOrder,
                          offset: context?.offset,
                          limit: context?.limit,
                          order: context?.order,
                          countryCodes: context?.countryCodes,
                          completion: completion)
    }
}
