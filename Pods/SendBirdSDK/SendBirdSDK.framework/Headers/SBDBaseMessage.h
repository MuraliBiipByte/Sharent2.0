//
//  SBDBaseMessage.h
//  SendBirdSDK
//
//  Created by Jed Gyeong on 5/30/16.
//  Copyright © 2016 SENDBIRD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDUser.h"

@class SBDBaseChannel;

/**
 *  The `SBDBaseMessage` class represents the base message which is generated by a user or an admin. The `SBDUserMessage`, the `SBDFileMessage` and the `SBDAdminMessage` are derived from this class.
 */
@interface SBDBaseMessage : NSObject <NSCopying>

/**
 *  Unique message ID.
 */
@property (atomic) long long messageId;

/**
 *  Channel URL which has this message.
 */
@property (strong, nonatomic, nullable) NSString *channelUrl;

/**
 *  Channel type of this message.
 */
@property (strong, nonatomic, nullable) NSString *channelType;

/**
 *  The list of users who was mentioned together with the message.
 *
 *  @since 3.0.90
 */
@property (strong, nonatomic, readonly, nullable) NSArray <SBDUser *> *mentionedUsers;

/**
 *
 *  @since 3.0.103
 */
@property (atomic, readonly) SBDMentionType mentionType;

/**
 *  Message created time in millisecond(UTC).
 */
@property (atomic) long long createdAt;

/**
 Message updated time in millisecond(UTC).
 */
@property (atomic) long long updatedAt;

/**
 Meta array.
 @since 3.0.116
 */
@property (nonatomic, nonnull, readonly, getter=getAllMetaArray) NSDictionary<NSString *, NSArray<NSString *> *> *metaArray;

/**
 *  The custom data for message.
 *
 *  @see Moved from `SBDUserMessage`, `SBDFileMessage`, `SBDAdminMessage`.
 */
@property (strong, nonatomic, readonly, nullable) NSString *data;

/**
 *  Custom message type.
 *
 *  @see Moved from `SBDUserMessage`, `SBDFileMessage`, `SBDAdminMessage`.
 */
@property (strong, nonatomic, readonly, nullable) NSString *customType;

/**
 *  Initializes a message object.
 *
 *  @param dict Dictionary data for a message.
 *
 *  @return SBDBaseMessage object.
 */
- (nullable instancetype)initWithDictionary:(NSDictionary * _Nonnull)dict;

/**
 *  Checks the channel type is open channel or not.
 *
 *  @return Returns YES, when this is open channel.
 */
- (BOOL)isOpenChannel;

/**
 *  Checks the channel type is group channel or not.
 *
 *  @return Returns YES, when this is group channel.
 */
- (BOOL)isGroupChannel;

/**
 Builds a message object from serialized <span>data</span>.
 
 @param data Serialized <span>data</span>.
 @return SBDBaseMessage object.
 */
+ (nullable instancetype)buildFromSerializedData:(NSData * _Nonnull)data;

/**
 Serializes message object.
 
 @return Serialized <span>data</span>.
 */
- (nullable NSData *)serialize;

/**
 Returns meta array for the keys.

 @param keys Keys of the meta array.
 @return Meta array of the keys.
 @since 3.0.116
 */
- (nonnull NSDictionary<NSString *, NSArray<NSString *> *> *)getMetaArrayWithKeys:(NSArray<NSString *> * _Nonnull)keys;

@end
