//
//  CKNetworkHelper.h
//  Snapoll
//
//  Created by Richard Lichkus on 5/1/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKAppDelegate.h"
#import <Parse/Parse.h>
#import "CKGroup.h"
#import "CKUser.h"

@interface CKNetworkHelper : NSObject

/// User

+(void)parseLogInWithUsername:(NSString*)username andPassword:(NSString*)password completionBlock:(void(^)(PFUser *user, NSError *error))completion;

/// Contacts

+(void)parseRetrieveContacts:(NSString*)userID WithCompletion:(void(^)(NSError *error))completion;

/// Group

+(void)parseRetrieveGroupsWithCompletion:(void(^)(NSError *error))completion;

+(void)parseAddNewGroup:(NSString*)groupName
         withCompletion:(void(^)(NSError *addGroupError, NSError *addGroupToUserError))completion;

+(void)parseAddExistingGroup:(NSString*)groupName withCompletion:(void(^)(NSError *addGroupError, NSError *addGroupToUserError))completion;

+(void)deleteGroupWithId:(NSString*)groupID withCompletion:(void(^)())completion;

/// Group Members

+(void)parseRetrieveGroupMembers:(NSString*)groupID WithCompletion:(void(^)(NSError *error))completion;

+(void)getUserInfo;

@end
