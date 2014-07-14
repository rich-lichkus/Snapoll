//
//  CKAllEventsVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKEvent.h"

@protocol CKAllEventsVCDelegate <NSObject>

-(void)didSelectPoll:(CKEvent*)selectedPoll;

@end

@interface CKAllEventsVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKAllEventsVCDelegate> delegate;

@end
