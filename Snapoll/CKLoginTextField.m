//
//  CKLoginTextField.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/7/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLoginTextField.h"

@implementation CKLoginTextField


-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

@end
