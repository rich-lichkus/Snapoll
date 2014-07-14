//
//  CKPollVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 7/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKEvent.h"

@protocol CKPollVCDelegate <NSObject>

-(void)didSelectPollExit;

@end

@interface CKPollVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKPollVCDelegate> delegate;

-(void)loadSelectedPoll:(CKEvent*)selectedPoll;

@end


