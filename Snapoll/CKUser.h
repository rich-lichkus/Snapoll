//
//  CKUser.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CKGroup.h"
#import "CKConstants.h"
@class CKGroup;

@interface CKUser : NSObject <NSCoding>

@property (strong, nonatomic) NSString *userID;         // objectId
@property (strong, nonatomic) NSString *userName;       // username
@property (strong, nonatomic) NSString *firstName;      // firstName
@property (strong, nonatomic) NSString *lastName;       // lastName
@property (strong, nonatomic) NSString *email;          // email
@property (nonatomic)         BOOL     emailVerified;   // emailVerified
@property (strong, nonatomic) NSString *twitterHandle;  // authData (somehow)
@property (strong, nonatomic) NSString *facebookHandle; // authData
@property (nonatomic) kUserStatus userStatus;

@property (strong, nonatomic) NSDate *createdAt;        // createdAt
@property (strong, nonatomic) NSDate *updatedAt;        // updatedAt
@property (strong, nonatomic) PFACL *acl;               // acl

@property (strong, nonatomic) NSMutableArray *groups;                   // groups
@property (strong, nonatomic) NSMutableArray *incomingGroupRequests;    // incomingGroupRequests

@property (strong, nonatomic) NSMutableArray *contacts;                 // contacts
@property (strong, nonatomic) NSMutableArray *incomingContactRequests;  // incomingContactRequests
@property (strong, nonatomic) NSMutableArray *outgoingContactRequests;  // outgoingContactRequests

@property (strong, nonatomic) NSMutableArray *allEvents; // allEvents
@property (strong, nonatomic) NSMutableArray *allPolls;  // allPolls

+(CKUser*)sharedCurrentUser;

-(instancetype)initPrimitivesWithPFUser:(PFUser*)userObject;

- (kUserStatus) getContactStatusForUserId:(NSString*)userId;








// Update the user's information
-(void)updateCurrentUserWithPFUser:(PFUser*)userObject;

// User's group methods
-(CKGroup*)getGroupWithId:(NSString*)groupID;
-(void)addGroupWithPFObject:(PFObject*)pfGroup;
-(void)updateCKGroup:(CKGroup*)ckGroup WithPFObject:(PFObject *)pfGroup;

// User's contacts methods
-(CKUser*)getContactWithId:(NSString*)userID;

//
-(void)addPendingGroupWithPFObject:(PFObject*)pfGroup;

@end
