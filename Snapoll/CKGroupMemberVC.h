//
//  CKGroupMemberVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKUser.h"
#import "CKGroup.h"
#import "CKNetworkHelper.h"
#import "CKNewMemberVC.h"

@interface CKGroupMemberVC : UIViewController

@property (strong, nonatomic) CKGroup *selectedGroup;

@end
