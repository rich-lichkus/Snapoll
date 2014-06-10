//
//  CKAddContactsTVCell.m
//  Snapoll
//
//  Created by Richard Lichkus on 5/9/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKAddContactsTVCell.h"

@implementation CKAddContactsTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellSelected = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
