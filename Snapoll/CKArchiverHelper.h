//
//  CKArchiverHelper.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/28/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKUser.h"
#import "CKAppDelegate.h"

@interface CKArchiverHelper : NSObject

+(NSString*) rootDocumentsPath;
+(NSString*) userDocumentsPath;

+(void)initialLoadUserDataFromArchive:(NSString*)username;
+(void)loadUserDataFromArchive;
+(BOOL)saveUserDataToArchive;

@end
