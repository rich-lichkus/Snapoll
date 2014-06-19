//
//  CKGroup.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroup.h"

@interface CKGroup(){

}

@end


@implementation CKGroup

#pragma mark - Initialize

-(instancetype) initWithCoder:(NSCoder*)aDecoder {
    
    if(self = [super init]) {
        
        self.groupID = [aDecoder decodeObjectForKey:@"groupID"];
        self.groupName = [aDecoder decodeObjectForKey:@"groupName"];
        self.members  = [aDecoder decodeObjectForKey:@"members"];
        self.incomingGroupRequests  = [aDecoder decodeObjectForKey:@"incomingGroupRequests"];
        self.outgoingGroupRequests  = [aDecoder decodeObjectForKey:@"outgoingGroupRequests"];
        self.messages = [aDecoder decodeObjectForKey:@"messages"];
        
        self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
        self.updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        self.acl = [aDecoder decodeObjectForKey:@"acl"];
        
        return self;
    }
    return nil;
}

-(void) encodeWithCoder:(NSCoder*)aCoder {
    
    [aCoder encodeObject:self.groupID forKey:@"groupID"];
    [aCoder encodeObject:self.groupName forKey:@"groupName"];
    [aCoder encodeObject:self.members forKey:@"members"];
    [aCoder encodeObject:self.incomingGroupRequests forKey:@"incomingGroupRequests"];
    [aCoder encodeObject:self.outgoingGroupRequests forKey:@"outgoingGroupRequests"];
    [aCoder encodeObject:self.messages forKey:@"messages"];

    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.updatedAt forKey:@"updateAt"];
    [aCoder encodeObject:self.acl forKey:@"acl"];
}

#pragma mark - Lazy Instansitation

-(NSMutableArray *)members{
    if(!_members){
        _members = [[NSMutableArray alloc] init];
    }
    return _members;
}

-(NSMutableArray *)incomingGroupRequests{
    if(!_incomingGroupRequests){
        _incomingGroupRequests = [[NSMutableArray alloc] init];
    }
    return _incomingGroupRequests;
}

-(NSMutableArray *)outgoingGroupRequests{
    if(!_outgoingGroupRequests){
        _outgoingGroupRequests = [[NSMutableArray alloc] init];
    }
    return _outgoingGroupRequests;
}

-(NSMutableArray*)messages{
    if(!_messages){
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

#pragma mark

-(CKUser*)getMemberWithId:(NSString*)userID{
    for(CKUser *user in self.members){
        if([user.userID isEqualToString:userID]){
            return user;
        }
    }
    return nil;
}

//-(PFUser*)getPendingMemberWithId:(NSString*)userID{
//    for(PFUser *user in self.pendingMembers){
//        if([user.objectId isEqualToString:userID]){
//            return user;
//        }
//    }
//    return nil;
//}

@end
