//
//  CKHotBoxRootVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKHotBoxRootVCDelegate <NSObject>

-(void)didMenuOpen:(BOOL)isOpen;

@end

@interface CKHotBoxRootVC : UIViewController

@property (unsafe_unretained, nonatomic) id <CKHotBoxRootVCDelegate> delegate;

@end
