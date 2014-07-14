//
//  CKLoginSegmentedControl.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/8/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLoginSegmentedControl.h"
#import "PaintCodeImages.h"

@interface CKLoginSegmentedControl ()

@end

@implementation CKLoginSegmentedControl



-(instancetype)initWithItems:(NSArray *)items{
    self = [super initWithItems:items];
    if (self){

        [self setBackgroundImage:[PaintCodeImages imageOfTwitterLoginWithSelected:YES] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];

    //[PaintCodeImages drawSegmentedLoginWithSelectedSegment:self.selectedSegmentIndex];

}



@end
