//
//  CKContactsVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CKNetworkHelper.h"

@protocol CKContactsVCDelegate <NSObject>

-(void)didSelectContact:(CKUser*)selectedContact;

@end

@interface CKContactsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (nonatomic, unsafe_unretained) id<CKContactsVCDelegate> delegate;

@end
