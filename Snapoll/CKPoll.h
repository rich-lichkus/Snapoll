//
//  CKPoll.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKMessage.h"

@interface CKPoll : CKMessage

// Poll Name
@property (strong, nonatomic) NSString *pollName;

// Array of questions (CKQuestions)
@property (strong, nonatomic) NSMutableArray *questions;


@end
