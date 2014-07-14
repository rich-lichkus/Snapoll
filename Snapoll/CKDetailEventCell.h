//
//  CKDetailEventCell.h
//  Snapoll
//
//  Created by Richard Lichkus on 7/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKDetailEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectionStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddOption;

@end
