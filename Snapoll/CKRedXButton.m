//
//  CKRedXButton.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/7/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKRedXButton.h"
#import "PaintCodeImages.h"

@implementation CKRedXButton

-(void)drawRect:(CGRect)rect{
    [PaintCodeImages drawCircleXIcon];
}

@end
