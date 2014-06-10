//
//  CKSimpleText.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKMessage.h"

@interface CKSimpleText : CKMessage

// Text Message
@property (strong, nonatomic) NSString *textMessage;

@end
