//
//  CKContactsCell.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKContactsCell.h"

@interface CKContactsCell()

- (IBAction)pressedContactImage:(id)sender;

@end

@implementation CKContactsCell


#pragma mark - Action Methods

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        NSLog(@"This is a log");
    }

    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)pressedContactImage:(id)sender {
    
}

@end
