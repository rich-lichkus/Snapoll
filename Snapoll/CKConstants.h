//
//  CKConstants.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, kUserStatus){
    kUserStatusContact = 0,
    kUserStatusIncomingContactRequest,
    kUserStatusOutgoingContactRequest,
    kUserStatusNotContact
};


typedef NS_ENUM (NSInteger, kMemberStatus){
    kUserStatusMember = 0,
    kUserStatusIncomingMemberRequest,
    kUserStatusOutgoingMemberRequest,
    kUserStatusNotMember
};


typedef NS_ENUM (NSInteger, kLoginOption){
    kFacebookLogin = 0,
    kTwitterLogin,
    kEmailLogin
};


typedef NS_ENUM (NSInteger, kMessageType){
    kSimpleTextMessage = 0,
    kEventMessage,
    kCustomPollMessage
};

typedef NS_ENUM (NSInteger, kPollStatus){
    kPollClosed = 0,
    kPollOpen,
    kPollFinalized
};

typedef NS_ENUM (NSInteger, kEventAttribute){
    kEventWhat = 0,
    kEventWhere,
    kEventWhen,
    kEventWho
};

@interface CKConstants : NSObject


@end
