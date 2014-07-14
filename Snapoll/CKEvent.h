//
//  CKEvent.h
//  Snapoll
//
//  Created by Richard Lichkus on 7/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKMessage.h"

@interface CKEvent : CKMessage

@property (strong, nonatomic) NSString *finalWhat;
@property (strong, nonatomic) NSDate *finalWhen;
@property (strong, nonatomic) NSString *finalWhereString;
@property (strong, nonatomic) NSMutableArray *finalAttendees;
@property (nonatomic) kPollStatus pollstatus;

@property (nonatomic) BOOL boolFinalWhat;
@property (nonatomic) BOOL boolFinalWhen;
@property (nonatomic) BOOL boolFinalWhere;
@property (nonatomic) BOOL boolFinalAttendees;

@property (strong, nonatomic) NSMutableArray *optionsWhat;
@property (strong, nonatomic) NSMutableArray *optionsWhere;
@property (strong, nonatomic) NSMutableArray *optionsWhen;
@property (strong, nonatomic) NSMutableArray *optionsWho;

@end
