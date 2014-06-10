//
//  CKGroupMenuVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/29/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKGroupVC.h"
#import "CKContactsVC.h"
#import "CKProfileVC.h"

@interface CKGroupMenuVC : UIViewController// <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CKGroupVC *groupVC;
@property (strong, nonatomic) CKContactsVC *contactsVC;
@property (strong, nonatomic) CKProfileVC *profileVC;
@property (strong, nonatomic) UIViewController *topVC;

@end
