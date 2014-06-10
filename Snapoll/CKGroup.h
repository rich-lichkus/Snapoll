//
//  CKGroup.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CKUser.h"
@class CKUser;

@interface CKGroup : NSObject <NSCoding>

@property (strong, nonatomic) NSString *groupID;                // objectID
@property (strong, nonatomic) NSString *groupName;              // name
@property (strong, nonatomic) NSMutableArray *members;          // members
@property (strong, nonatomic) NSMutableArray *pendingMembers;   // pendingMembers
@property (strong, nonatomic) NSMutableArray *messages;         // messages

@property (strong, nonatomic) NSDate *createdAt;                // createdAt
@property (strong, nonatomic) NSDate *updatedAt;                // updatedAt
@property (strong, nonatomic) PFACL *acl;                       // ACL

-(CKUser*)getMemberWithId:(NSString*)userID;
-(PFUser*)getPendingMemberWithId:(NSString*)userID;
@end
