//
//  CKGroupVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKAppDelegate.h"
#import "CKUser.h"
#import "CKGroup.h"
#import "CKChatVC.h"
#import "CKNetworkHelper.h"
#import "CKHotBoxRootVC.h"

@interface CKGroupVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void) configureParentDelegate:(CKHotBoxRootVC*)parentVC;

@end
