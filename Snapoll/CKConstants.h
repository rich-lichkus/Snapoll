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

@interface CKConstants : NSObject


@end
