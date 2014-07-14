//
//  CKGroupEventsVC.h
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKEvent.h"

@protocol CKGroupEventsVCDelegate <NSObject>

-(void)didSelectPoll:(CKEvent*)selectedPoll;

@end

@interface CKGroupEventsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblGroupEvents;
@property (nonatomic, unsafe_unretained) id<CKGroupEventsVCDelegate> delegate;

@end
