//
//  CKProfileVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 5/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKUser.h"

@protocol CKProfileVCDelegate <NSObject>

-(void)didSelectProfileExit;

@end

@interface CKProfileVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKProfileVCDelegate> delegate;

-(void)loadSelectedContact:(CKUser*)selectedContact;

@end
