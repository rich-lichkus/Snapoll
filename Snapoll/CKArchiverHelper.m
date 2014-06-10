//
//  CKArchiverHelper.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/28/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKArchiverHelper.h"


@implementation CKArchiverHelper

+(NSString*)rootDocumentsPath {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL path];
}

+(NSString*)userDocumentsPath{
    
    return [[CKArchiverHelper rootDocumentsPath] stringByAppendingPathComponent:((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser.userName];
}

+(void)initialLoadUserDataFromArchive:(NSString*)username{
    
    NSString *path = [[CKArchiverHelper rootDocumentsPath] stringByAppendingPathComponent:username];
    if([[NSFileManager defaultManager]fileExistsAtPath:path]){
        // Load
        ((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } else {
        //Create a new one
        ((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser = [[CKUser alloc] init];
        [NSKeyedArchiver archiveRootObject:((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser toFile:path];
    }
}

+(void)loadUserDataFromArchive{
    ((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[CKArchiverHelper userDocumentsPath]];
}

+(BOOL)saveUserDataToArchive{
//    return [NSKeyedArchiver archiveRootObject:((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser toFile:[CKArchiverHelper userDocumentsPath]];
    return YES;
}

@end
