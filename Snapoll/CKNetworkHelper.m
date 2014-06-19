
//
//  CKNetworkHelper.m
//  Snapoll
//
//  Created by Richard Lichkus on 5/1/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKNetworkHelper.h"
#import "CKArchiverHelper.h"

@implementation CKNetworkHelper

//--------------------------------------------------------------------------------------------------------------
// User Level
//--------------------------------------------------------------------------------------------------------------

// Login
//--------------------------------------------------------------------

+(void)parseLogInWithUsername:(NSString*)username andPassword:(NSString*)password completionBlock:(void(^)(PFUser *user, NSError *error))completion{

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        completion(user, error);
    }];
}

// Retrieve User's Groups
//--------------------------------------------------------------------

+(void)parseRetrieveGroupsWithCompletion:(void(^)(NSError *error))completion {
    
    // Current user instance
    CKUser *currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    // Parse query to get user's groups, using user's ID
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId"equalTo:currentUser.userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(objects.count > 0) {
            // Parse query to get relational groups for user
            PFUser *user = objects[0];
            PFRelation *groupRelation = [user relationForKey:@"groups"];
            PFQuery *query = [groupRelation query];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                [currentUser.groups removeAllObjects];
                
                for (PFObject *groupObject in objects) {
                    [currentUser addGroupWithPFObject:groupObject];
                }
                
                completion(error);
            }];
        } else {
            NSLog(@"No user found.");
        }
    }];
}

// Retrieve User's Contacts, Incoming Requests, Outgoing Requests
//--------------------------------------------------------------------

+(void)parseRetrieveContacts:(NSString*)userID WithCompletion:(void(^)(NSError *error))completion{
    
    CKUser *currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    // Retrieve Contacts
    PFRelation *contactRelation = [[PFUser currentUser] relationForKey:@"contacts"];
    PFQuery *cRelation = contactRelation.query;
    [cRelation orderByAscending:@"firstName"];
    [cRelation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [currentUser.contacts removeAllObjects];
        
        for(PFUser *contact in objects){
            
            CKUser *newMember = [[CKUser alloc]initPrimitivesWithPFUser:contact];
            newMember.userStatus = kUserStatusContact;
            [currentUser.contacts addObject:newMember];
            
        }
        completion(error);
    }];
    
    // Retreive Contact Incoming Requests
    PFQuery *contactInvitationQuery = [PFQuery queryWithClassName:@"ContactInvitations"];
    [contactInvitationQuery whereKey:@"to_user" equalTo:[PFUser currentUser]];
    [contactInvitationQuery includeKey:@"from_user"];
    [contactInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [currentUser.incomingContactRequests removeAllObjects];
        
        for(PFObject *invitation in objects){
            
            PFUser *contact = invitation[@"from_user"];
            
            CKUser *newMember = [[CKUser alloc]initPrimitivesWithPFUser:contact];
            newMember.userStatus = kUserStatusIncomingContactRequest;
            [currentUser.incomingContactRequests addObject:newMember];
            
        }
        completion(error);
    }];
    
    // Retreive Contact Outgoing Requests
    PFQuery *contactOutgoingInvitationQuery = [PFQuery queryWithClassName:@"ContactInvitations"];
    [contactOutgoingInvitationQuery whereKey:@"from_user" equalTo:[PFUser currentUser]];
    [contactOutgoingInvitationQuery includeKey:@"to_user"];
    [contactOutgoingInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [currentUser.outgoingContactRequests removeAllObjects];
        
        for(PFObject *invitation in objects){
            
            PFUser *contact = invitation[@"to_user"];
            
            CKUser *newMember = [[CKUser alloc]initPrimitivesWithPFUser:contact];
            newMember.userStatus = kUserStatusOutgoingContactRequest;
            [currentUser.outgoingContactRequests addObject:newMember];
        
        }
        completion(error);
    }];
    
//    // add in pointer invitation to and from
//    PFQuery *userq = [PFUser query];
//    [userq getObjectInBackgroundWithId:@"FsrM2q4mvH" block:^(PFObject *object, NSError *error) {
//        PFObject *newInvitation = [PFObject objectWithClassName:@"ContactInvitations"];
//        newInvitation[@"from_user"] = [PFUser currentUser];
//        newInvitation[@"to_user"] = object;
//        [newInvitation saveInBackground];
//    }];
    
}


//--------------------------------------------------------------------------------------------------------------
// Group Level
//--------------------------------------------------------------------------------------------------------------

// Retrieve Members, Outgoing Requests, Incoming Requests
//--------------------------------------------------------------------

+(void)parseRetrieveGroupMembers:(NSString*)groupID WithCompletion:(void(^)(NSError *error))completion {
    
    CKUser *currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery getObjectInBackgroundWithId:groupID block:^(PFObject *groupObject, NSError *error) {
        
        CKGroup *ckGroup = [currentUser getGroupWithId:groupID];
        
        // Retrieve Group Members
        PFRelation *membersRelation = [groupObject relationForKey:@"members"];
        [[membersRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            [ckGroup.members removeAllObjects];
            
            if(ckGroup){
                for(PFUser *pfUser in objects){
                    CKUser *ckMember = [[CKUser alloc]initPrimitivesWithPFUser:pfUser];
                    ckMember.userStatus = kUserStatusContact;
                    [ckGroup.members addObject:ckMember];
                }
            }
            completion(error);
        }];
        
        // Retreive Group Outgoing Requests
        PFQuery *memberInvitationQuery = [PFQuery queryWithClassName:@"GroupInvitations"];
        [memberInvitationQuery whereKey:@"from_user" equalTo:[PFUser currentUser]];
        [memberInvitationQuery includeKey:@"to_user"];
        [memberInvitationQuery includeKey:@"group"];
        [memberInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            [ckGroup.incomingGroupRequests removeAllObjects];

                for(PFObject *invitation in objects){

                    PFUser *contact = invitation[@"to_user"];

                    CKUser *newMember = [[CKUser alloc]initPrimitivesWithPFUser:contact];
                    newMember.userStatus = kUserStatusOutgoingContactRequest;
                    [ckGroup.outgoingGroupRequests addObject:newMember];
                }
                completion(error);
         }];
    
//        // Retreive Group Incoming Requests
//        PFQuery *memberInvitationQuery = [PFQuery queryWithClassName:@"GroupInvitations"];
//        [memberInvitationQuery whereKey:@"to_user" equalTo:[PFUser currentUser]];
//        [memberInvitationQuery includeKey:@"from_user"];
//        [memberInvitationQuery includeKey:@"group"];
//        [memberInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//
//            [ckGroup.incomingGroupRequests removeAllObjects];
//
//                for(PFObject *invitation in objects){
//                    
//                    PFUser *contact = invitation[@"from_user"];
//
//                    CKUser *newMember = [[CKUser alloc]initPrimitivesWithPFUser:contact];
//                    newMember.userStatus = kUserStatusIncomingContactRequest;
//                        
//                    [ckGroup.incomingGroupRequests addObject:newMember];
//                }
//                completion(error);
//         }];
        
//        //add in pointer invitation to and from member
//        PFQuery *userq = [PFUser query];
//        [userq getObjectInBackgroundWithId:@"FsrM2q4mvH" block:^(PFObject *object, NSError *error) {
//            PFObject *newInvitation = [PFObject objectWithClassName:@"GroupInvitations"];
//            newInvitation[@"from_user"] = [PFUser currentUser];
//            newInvitation[@"to_user"] = object;
//            newInvitation[@"group"] = groupObject;
//            [newInvitation saveInBackground];
//        }];
//        
    }];
    

 
    
    
    
}





















/// Add New Group to a User
+(void)parseAddNewGroup:(NSString*)groupName
         withCompletion:(void(^)(NSError *addGroupError, NSError *addGroupToUserError))completion {
    // Save new group to parse, if success, save locally
    PFObject *groupObject = [PFObject objectWithClassName:@"Group"];
    
    // Add group name
    groupObject[@"name"] = groupName;
    [groupObject incrementKey:@"memberCount"];
    
    // Add user to the new group
    PFRelation *newMemberRelation = [groupObject relationForKey:@"members"];
    [newMemberRelation addObject:[PFUser currentUser]];
    [groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *groupError) {
        if(succeeded){
            
            // Add group to user
            PFUser *user = [PFUser currentUser];
            PFRelation *relation = [user relationforKey:@"groups"];
            [relation addObject:groupObject];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *groupToUserError) {
                if(succeeded){
                    
                    CKUser *ckUser = ((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser;
                    [ckUser addGroupWithPFObject:groupObject];
                    
                }
                completion(groupError, groupToUserError);
            }];
        }
    }];
}

+(void)parseAddExistingGroup:(NSString*)groupName withCompletion:(void(^)(NSError *addGroupError, NSError *addGroupToUserError))completion {
    
}

+(void)deleteGroupWithId:(NSString*)groupID withCompletion:(void(^)())completion {

    // Deleting a group
    
    // get group via id
    // remove group from user's list
    // if (memberCount == 1)
    //  delete group from parse
    // else {
    //  remove user from group's member list
    // }
    
    // Get group to delete
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"Group"];
    [groupQuery getObjectInBackgroundWithId:groupID block:^(PFObject *object, NSError *error) {
        
        // Delete group relation from user
        PFUser *currentUser = [PFUser currentUser];
        PFRelation *groupRelation = [currentUser relationForKey:@"groups"];
        [groupRelation removeObject:object];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *memberError) {
            
            NSNumber *memberCount = object[@"memberCount"];
            if(memberCount.integerValue == 1){
                // Delete entire group from parse
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    completion(nil,memberError);
                }];
                
            } else {
                // Delete user relation from groups
                PFRelation *userRelation = [object relationForKey:@"members"];
                [userRelation removeObject:[PFUser currentUser]];
                [object incrementKey:@"memberCount" byAmount:@-1];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *userError) {
                    completion(userRelation,memberError);
                }];
            }
        }];
    }];
}



//------------------------------------
// Members
//    retrieveGroupMembers
//    inviteGroupMembers
//    removeGroupMembers
//------------------------------------



+(void)getUserInfo{
    
    CKUser *currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
//
//    // Retrieve Groups
//    
//    PFRelation *groupRelation = [[PFUser currentUser ]relationForKey:@"groups"];
//    PFQuery *pendingMemberQuery = [groupRelation query];
//    [pendingMemberQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//    }];
    
    // Retrieve incoming contact requests
    
//    PFQuery *contactInvitationQuery = [PFQuery queryWithClassName:@"ContactInvitations"];
//    [contactInvitationQuery whereKey:@"to_user_id" equalTo:[PFUser currentUser].objectId];
//    [contactInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for(PFObject *userId in objects){
//            PFQuery *user = [PFUser query];
//            [user getObjectInBackgroundWithId:userId[@"to_user_id"] block:^(PFObject *object, NSError *error) {
//                [currentUser.incomingContactRequests addObject:object];
//            }];
//        }
//    }];
    
    // This all invitations to current user
//    PFQuery *contactInvitationQuery = [PFQuery queryWithClassName:@"ContactInvitations"];
//    [contactInvitationQuery whereKey:@"to_user_id" equalTo:[PFUser currentUser].objectId];
//
//    // get the user that matches the from_user
//    PFQuery *fromUserQuery = [PFQuery queryWithClassName:@"_User"];
//    [fromUserQuery whereKey:@"objectId" matchesKey:@"from_user_id" inQuery:contactInvitationQuery];
//    
//    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects: fromUserQuery, nil]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSLog(@"%@",objects[0][@"username"]);
//    }];
    
    
    //*******
    // Model pointer with included primitives and nested pointers
    //*******
    
//    PFQuery *contactInvitationQuery = [PFQuery queryWithClassName:@"ContactInvitations"];
//    [contactInvitationQuery whereKey:@"to_user" equalTo:[PFUser currentUser]];
//    [contactInvitationQuery includeKey:@"from_user"];
//    [contactInvitationQuery includeKey:@"from_user.groups"];
//    [contactInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        [currentUser.incomingContactRequests removeAllObjects];
//        
//        for(PFObject *invitation in objects){
//            [currentUser.incomingContactRequests addObject:invitation[@"from_user"]];
//        
//        }
//        
////        NSLog(@"%@",objects[0][@"from_user"][@"groups"][0][@"name"]); // Not allowed, groups is relational
//        
//    }];
    
    
    //******
    // relational data
    //*******
    
//    PFRelation *usersContactRelation = [[PFUser currentUser] relationForKey:@"contacts"];
//    PFRelation *usersGroupsRelation = [[PFUser currentUser] relationForKey:@"groups"];
//    
//    PFQuery *getUserData = [usersContactRelation query];
//    [getUserData findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//    }];
    
//    [contactInvitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        for(PFObject *userObject in objects){
//            
////            PFQuery *user = [PFUser query];
////            [user getObjectInBackgroundWithId:userId[@"to_user_id"] block:^(PFObject *object, NSError *error) {
////                [currentUser.incomingContactRequests addObject:object];
////            }];
//        }
//    }];
    
    // Retreive outgoing contact requests

}

//    /// Add contacts to user
//
//    PFUser *currentUser = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//    [query getObjectWithId:@"jQwtqGqkKr"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        PFRelation *contactsRelation = [currentUser relationForKey:@"contacts"];
//        [contactsRelation addObject:objects[0]];
//        [currentUser saveInBackground];
//        NSLog(@"Added your ass, bitch");
//    }];

// Code to seed all groups relationally to the current user

//    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for(PFObject *group in objects){
//            PFUser *user = [PFUser currentUser];
//            PFRelation *relation = [user relationforKey:@"groups"];
//            [relation addObject:group];
//            [user saveInBackground];
//        }
//    }];

//    PFQuery *inContactRequest = [PFQuery queryWithClassName:@"ContactInvitations"];
//    [inContactRequest whereKey:@"to_user_id" equalTo:currentUser.userID];
//    [inContactRequest findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(objects.count>0) {
//            for(PFObject *contactInvite in objects){
//                PFQuery *queryUser = [PFQuery queryWithClassName:@"User"];
//                [queryUser whereKey:@"objectId" equalTo: contactInvite[@"from_user_id"]];
//                [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    if(objects.count>0){
//
//                        [currentUser.incomingContactRequests removeAllObjects];
//
//                        for(PFObject *contact in objects){
//                            CKUser *newMember = [[CKUser alloc]init];
//                                newMember.userID = contact.objectId;
//                                newMember.userName = contact[@"username"];
//                                newMember.firstName = contact[@"firstName"];
//                                newMember.lastName = contact[@"lastName"];
//                                newMember.updatedAt = contact.updatedAt;
//                                newMember.createdAt = contact.createdAt;
//                                [currentUser.incomingContactRequests addObject:newMember];
//                        }
//                    }
//                }];
//            }
//        }
//    }];

@end
