//
//  CKChatVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKGroup.h"

@interface CKChatVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *colMessages;
@property (strong, nonatomic) CKGroup *selectedGroup;

@end
