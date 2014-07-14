//
//  CKOutSimpleMessageCell.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKOutSimpleMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatarBadge;
@property (weak, nonatomic) IBOutlet UITextView *txvMessage;


@end
