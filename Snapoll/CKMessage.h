//
//  CKMessage.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKUser.h"

@interface CKMessage : NSObject

// Message ID
@property (strong, nonatomic) NSString *messageID;

// User Creator
@property (strong, nonatomic) CKUser *creator;

// Date Created
@property (strong, nonatomic) NSDate *dateCreated;

@end
