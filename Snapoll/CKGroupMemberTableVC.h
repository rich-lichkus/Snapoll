//
//  CKGroupMemberTableVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKUser.h"
#import "CKGroup.h"
#import "CKNetworkHelper.h"
#import "CKNewMemberVC.h"

@interface CKGroupMemberTableVC : UITableViewController

@property (strong, nonatomic) CKGroup *selectedGroup;

@end
