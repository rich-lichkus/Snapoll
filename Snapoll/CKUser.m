//
//  CKUser.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKUser.h"
#import <Parse/Parse.h>
#import "CKAppDelegate.h"

@implementation CKUser

+(CKUser*)sharedCurrentUser{
    static dispatch_once_t pred;
    static CKUser *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CKUser alloc]init];
    });
    return shared;
}

-(instancetype)init{
    self  = [super init];
    if (self) {
    
    
    }
    return self;
}

#pragma mark - Lazy Instantiation

-(NSMutableArray *)groups{
    if(!_groups){
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

-(NSMutableArray *)incomingGroupRequests{
    if(!_incomingGroupRequests){
        _incomingGroupRequests = [[NSMutableArray alloc] init];
    }
    return _incomingGroupRequests;
}

-(NSMutableArray *)contacts{
    if(!_contacts){
        _contacts = [[NSMutableArray alloc] init];
    }
    return _contacts;
}

-(NSMutableArray *)incomingContactRequests{
    if(!_incomingContactRequests){
        _incomingContactRequests = [[NSMutableArray alloc] init];
    }
    return _incomingContactRequests;
}

-(NSMutableArray *)outgoingContactRequests{
    if(!_outgoingContactRequests){
        _outgoingContactRequests = [[NSMutableArray alloc] init];
    }
    return _outgoingContactRequests;
}

-(NSMutableArray *)allEvents{
    if(!_allEvents){
        _allEvents = [[NSMutableArray alloc] init];
    }
    return _allEvents;
}

-(NSMutableArray *)allPolls{
    if(!_allPolls){
        _allPolls = [[NSMutableArray alloc] init];
    }
    return _allPolls;
}

#pragma mark - NSCoder

-(instancetype) initWithCoder:(NSCoder*)aDecoder {

    if(self = [super init]) {
    
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.userName  = [aDecoder decodeObjectForKey:@"userName"];
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.emailVerified = [aDecoder decodeBoolForKey:@"emailVerified"];
        self.twitterHandle = [aDecoder decodeObjectForKey:@"twitterHandle"];
        self.facebookHandle  = [aDecoder decodeObjectForKey:@"facebookHandle"];
        
        self.groups = [aDecoder decodeObjectForKey:@"groups"];
        self.incomingGroupRequests = [aDecoder decodeObjectForKey:@"incomingGroupRequests"];
        self.contacts = [aDecoder decodeObjectForKey:@"contacts"];
        self.incomingContactRequests = [aDecoder decodeObjectForKey:@"incomingContactRequests"];
        self.outgoingContactRequests = [aDecoder decodeObjectForKey:@"outgoingContactRequests"];
        self.allEvents = [aDecoder decodeObjectForKey:@"allEvents"];
        self.allPolls   = [aDecoder decodeObjectForKey:@"allPolls"];
        
        self.createdAt = [aDecoder decodeObjectForKey:@"crxeatedAt"];
        self.updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        self.acl = [aDecoder decodeObjectForKey:@"acl"];
    
        return self;
    }
    return nil;
}

-(void) encodeWithCoder:(NSCoder*)aCoder {

    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeBool:self.emailVerified forKey:@"emailVerified"];
    [aCoder encodeObject:self.twitterHandle forKey:@"twitterHandle"];
    [aCoder encodeObject:self.facebookHandle forKey:@"facebookHandle"];
    
    [aCoder encodeObject:self.groups forKey:@"groups"];
    [aCoder encodeObject:self.incomingGroupRequests forKey:@"incomingGroupRequests"];
    [aCoder encodeObject:self.contacts forKey:@"contacts"];
    [aCoder encodeObject:self.incomingContactRequests forKey:@"incomingContactRequests"];
    [aCoder encodeObject:self.outgoingContactRequests forKey:@"outgoingContactRequests"];
    [aCoder encodeObject:self.allEvents forKey:@"allEvents"];
    [aCoder encodeObject:self.allPolls forKey:@"allPolls"];
    
    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:self.acl forKey:@"acl"];

}

//-- User methods

-(void)updateCurrentUserWithPFUser:(PFUser*)user{
    
    self.userID = user.objectId;
    self.userName = user[@"username"];
    self.firstName = user[@"firstName"];
    self.lastName = user[@"lastName"];
    self.email = user[@"email"];
    self.emailVerified = user[@"emailVerified"];
    self.twitterHandle = user[@"twitterHandle"];
    self.facebookHandle = user[@"facebookHandle"];
    
    self.createdAt = user.createdAt;
    self.updatedAt = user.updatedAt;
    self.acl = user.ACL;
}

//-- Group methods

- (CKGroup*)getGroupWithId:(NSString*)groupID{
    for(CKGroup *group in self.groups){
        if([group.groupID isEqualToString:groupID]){
            return group;
        }
    }
    return nil;
}

- (void)addGroupWithPFObject:(PFObject*)pfGroup{
    
    CKGroup *group = [[CKGroup alloc] init];
    
    group.groupID = pfGroup.objectId;
    group.groupName = pfGroup[@"name"];
    
    group.createdAt = pfGroup.createdAt;
    group.updatedAt = pfGroup.updatedAt;
    group.acl = pfGroup.ACL;
    
    [self.groups addObject:group];
    
    [CKArchiverHelper saveUserDataToArchive];
}

- (void)updateCKGroup:(CKGroup*)ckGroup WithPFObject:(PFObject *)pfGroup{
    
    ckGroup.groupID = pfGroup.objectId;
    ckGroup.groupName = pfGroup[@"name"];
    
    ckGroup.createdAt = pfGroup.createdAt;
    ckGroup.updatedAt = pfGroup.updatedAt;
    ckGroup.acl = pfGroup.ACL;
    
    [CKArchiverHelper saveUserDataToArchive];
}

- (void)addExistingGroupWithPFObject:(PFObject*)pf{
    
}

- (void)addPendingGroupWithPFObject:(PFObject*)pfGroup{
    
    CKGroup *group = [[CKGroup alloc] init];
    
    group.groupID = pfGroup.objectId;
    group.groupName = pfGroup[@"name"];
    
    group.createdAt = pfGroup.createdAt;
    group.updatedAt = pfGroup.updatedAt;
    group.acl = pfGroup.ACL;
    
    [self.incomingGroupRequests addObject:group];
    
    [CKArchiverHelper saveUserDataToArchive];
}

// Contact methods
-(CKUser*)getContactWithId:(NSString*)userID{
    for(CKUser *contacts in self.contacts){
        if([contacts.userID isEqualToString:userID]){
            return contacts;
        }
    }
    return nil;
}


@end
