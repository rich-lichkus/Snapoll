//
//  CKSemiCircleButton.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/7/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKSemiCircleButton.h"
#import "PaintCodeImages.h"

@implementation CKSemiCircleButton

-(void)drawRect:(CGRect)rect{
    [PaintCodeImages drawSemiCircleSlideIndicatorIcon];
}

@end
