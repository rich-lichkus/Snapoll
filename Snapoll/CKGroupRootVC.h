//
//  CKGroupRootVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKGroup.h"
#import "CKChatVC.h"
@class CKChatVC;

@protocol CKGroupRootVCDelegate <NSObject>
@required
-(void)didMenuOpen:(BOOL)isOpen;

@end

@interface CKGroupRootVC : UIViewController

@property (unsafe_unretained, nonatomic) id <CKGroupRootVCDelegate> delegate;
@property (strong, nonatomic) CKGroup *selectedGroup;
@property (strong, nonatomic) CKChatVC *chatVC;

@end
