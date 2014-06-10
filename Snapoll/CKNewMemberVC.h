//
//  CKNewMemberVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 5/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKNetworkHelper.h"
#import "CKAddContactsTVCell.h"
#import <Parse/Parse.h>
#import "CKUser.h"

@interface CKNewMemberVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) CKGroup *selectedGroup;

@end
