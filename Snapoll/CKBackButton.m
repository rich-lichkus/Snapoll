//
//  CKBackButton.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/7/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKBackButton.h"
#import "PaintCodeImages.h"

@implementation CKBackButton

-(void)drawRect:(CGRect)rect{
    [PaintCodeImages drawCircleRightBackArrow];
}

@end
