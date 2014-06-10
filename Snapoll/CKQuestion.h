//
//  CKQuestion.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKQuestion : NSObject

@property (nonatomic) BOOL hasDeadline;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSTimeInterval *timeToDeadline;

@property (nonatomic) BOOL requiredResponse;
@property (nonatomic) BOOL publicResults;
@property (nonatomic) BOOL annonymous;

@end
