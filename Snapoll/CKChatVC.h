//
//  CKChatVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKGroup.h"
#import "CKGroupRootVC.h"
@class CKGroupRootVC;

@interface CKChatVC : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblMessages;

-(void) configureParentDelegate:(CKGroupRootVC*)parentVC;
-(void)scrollTableAnimated:(BOOL)animated;

@end
