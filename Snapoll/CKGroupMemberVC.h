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
#import "CKGroupRootVC.h"

@protocol CKGroupMemberVCDelegate <NSObject>

-(void)didSelectContact:(CKUser*)selectedContact;

@end


@interface CKGroupMemberVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKGroupMemberVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblGroupMember;

@property (weak, nonatomic) CKGroupRootVC *parentVC;

@end
