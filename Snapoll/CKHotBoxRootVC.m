//
//  CKHotBoxRootVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKHotBoxRootVC.h"
#import "CKAllEventsVC.h"
#import "CKContactsVC.h"
#import "CKGroupVC.h"
#import "CKProfileVC.h"
#import "CKNetworkHelper.h"
#import "CKPollVC.h"

@interface CKHotBoxRootVC () <UIGestureRecognizerDelegate, CKContactsVCDelegate, CKProfileVCDelegate, CKAllEventsVCDelegate, CKPollVCDelegate>

@property (strong, nonatomic) CKUser *currentUser;
@property (strong, nonatomic) CKProfileVC *profileVC;
@property (strong, nonatomic) CKPollVC *pollVC;
@property (strong, nonatomic) CKAllEventsVC *allEventsVC;
@property (strong, nonatomic) CKContactsVC *contactsVC;
@property (strong, nonatomic) CKGroupVC *groupsVC;

@property (nonatomic, getter = isMenuOpen) BOOL menuOpen;
@property (nonatomic, getter = isContactsVisible) BOOL contactsVisible;

@end

@implementation CKHotBoxRootVC

#pragma mark - Views

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configureChildVCs];
    
    [self setupPanGesture];
    
    [self setupParse];
}

#pragma mark - Configure and Setup Functions

-(void)configureChildVCs{
    
    [self addChildViewController:self.contactsVC];
    [self.contactsVC didMoveToParentViewController:self];
    [self.view addSubview:self.contactsVC.view];

    [self addChildViewController:self.allEventsVC];
    [self.allEventsVC didMoveToParentViewController:self];
    [self.view addSubview:self.allEventsVC.view];
    
    [self addChildViewController:self.groupsVC];
    [self.groupsVC didMoveToParentViewController:self];
    [self.view addSubview:self.groupsVC.view];
    
    self.contactsVisible = YES;
}

-(void)setupPanGesture{
    
    self.menuOpen = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    
    panGesture.delegate = self;
    panGesture.delaysTouchesBegan = YES;
    panGesture.delaysTouchesEnded = YES;
    
    [self.groupsVC.view addGestureRecognizer:panGesture];
}

-(void)setupParse{
    // Retrieve User's Contacts, Incoming Requests, Outgoing Requests
    [CKNetworkHelper parseRetrieveContacts:self.currentUser.userID WithCompletion:^(NSError *error) {
        //[CKArchiverHelper saveUserDataToArchive];
        [self.contactsVC.tblContacts reloadData];
    }];
    
    // Retrieve User's Groups
    [CKNetworkHelper parseRetrieveGroupsWithCompletion:^(NSError *error) {
        
    }];
    
    // Retrieve User's Events
    // Retrieve User's Polls
    
    
    
//    // Cloud Code Example
//    [PFCloud callFunctionInBackground:@"getGroup"
//                       withParameters:@{@"objectId": @"1HWBsB55wl"}
//                                block:^(NSString *name, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", name);
//        }
//    }];
//    
//    [PFCloud callFunctionInBackground:@"hello" withParameters: @{} block:^(id object, NSError *error) {
//        if(!error){
//            NSLog(@"%@", object);
//        }
//    }];

//    [PFCloud callFunctionInBackground:@"getUsersGroups"
//                       withParameters:@{@"objectId": [[PFUser currentUser]objectId]}
//                                block:^(id result, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", result);
//        }
//    }];
    
//    [PFCloud callFunctionInBackground:@"getUsersHotBoxData"
//                       withParameters:@{@"objectId": [PFUser currentUser].objectId}
//                                block:^(id response, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", response);
//        }
//    }];
    
//    PFUser *current = [PFUser currentUser];

//    [PFCloud callFunctionInBackground:@"groupContactInvitation"
//                       withParameters:@{ @"to_user" : @"Vv6Ouh0xtm",
//                                         @"groupId" : @""}
//                                block:^(id object, NSError *error) {
//        NSLog(@"%@", object);
//    }];
    
    
//    [PFCloud callFunctionInBackground:@"sendGroupInvitation"
//                        withParameters:@{@"to_user": @"jQwtqGqkKr",
//                                         @"groupId": @"bn44oidqbJ" }
//                                   block:^(id response, NSError *error) {
//        if (!error) {
//           NSLog(@"%@", response);
//       }
//    }];
    
//  [PFCloud callFunctionInBackground:@"getUsersGroups"
//                     withParameters:@{@"objectId": [[PFUser currentUser]objectId]}
//                              block:^(id response, NSError *error) {
//    if (!error) {
//       // NSLog(@"%@", user);
//    }
//  }];
    

}

#pragma mark - Slide Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point = [touch locationInView:self.groupsVC.view];
   
    if (self.isMenuOpen){
        return YES;
    } else if ((point.x >=0 && point.x <=30) || (point.x <=320 && point.x >=290)){
        return YES;
    } else {
        return NO;
    }
}

-(void)slidePanel:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    
    CGPoint viewTranslation = [panGesture translationInView:self.groupsVC.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
            // Open Menu Left
            if(self.groupsVC.view.frame.origin.x+viewTranslation.x>=0 &&
               self.groupsVC.view.frame.origin.x+viewTranslation.x<= self.groupsVC.view.frame.size.width*.75)
            {
                if (!self.isContactsVisible) {
                    [self makeContactsVCVisible];
                }

                self.groupsVC.view.center = CGPointMake(self.groupsVC.view.center.x+viewTranslation.x, self.groupsVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            // Open Menu Right
            } else if (self.groupsVC.view.frame.origin.x+viewTranslation.x<0 &&
                       self.groupsVC.view.frame.origin.x+viewTranslation.x>= -self.groupsVC.view.frame.size.width*.75)
            {
                if (self.isContactsVisible) {
                    [self makeAllEventsVCVisible];
                }
                
                self.groupsVC.view.center = CGPointMake(self.groupsVC.view.center.x+viewTranslation.x, self.groupsVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            if(self.groupsVC.view.frame.origin.x > self.view.frame.size.width/4){
                [self openLeftMenu];
            } else if(self.groupsVC.view.frame.origin.x < -self.view.frame.size.width/4){
                [self openRightMenu];
            } else if (self.groupsVC.view.frame.origin.x < self.view.frame.size.width/2){
                [self closeMenu];
            }
            
            break;
    }
}

-(void) openRightMenu{
    [UIView animateWithDuration:.4 animations:^{
        self.groupsVC.view.frame = CGRectMake(-self.view.frame.size.width*.75,
                                           self.groupsVC.view.frame.origin.y,
                                           self.groupsVC.view.frame.size.width,
                                           self.groupsVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuOpen = YES;
        [self.delegate didMenuOpen:YES];
    }];
}

-(void) openLeftMenu{
    [UIView animateWithDuration:.4 animations:^{
        self.groupsVC.view.frame = CGRectMake(self.view.frame.size.width*.75,
                                           self.groupsVC.view.frame.origin.y,
                                           self.groupsVC.view.frame.size.width,
                                           self.groupsVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuOpen = YES;
        [self.delegate didMenuOpen:YES];
    }];
}

-(void) closeMenu{
    [self.groupsVC.view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.4 animations:^{
        self.groupsVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.menuOpen = NO;
        [self.delegate didMenuOpen:NO];
    }];
}

-(void) makeContactsVCVisible{
//    [self.contactsVC.view removeFromSuperview];
//    [self.groupsVC.view removeFromSuperview];
//    [self.view addSubview:self.contactsVC.view];
//    [self.view addSubview:self.groupsVC.view];
    
    if(self.profileVC){
        self.profileVC.view.frame = CGRectOffset(self.profileVC.view.frame, 640, 0);
    }
    if(self.pollVC){
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, 640, 0);
    }
    self.contactsVC.view.frame = CGRectOffset(self.contactsVC.view.frame, 640, 0);
    self.allEventsVC.view.frame = CGRectOffset(self.allEventsVC.view.frame, 640, 0);
    
    self.contactsVisible = YES;
}

-(void) makeAllEventsVCVisible{
//    [self.allEventsVC.view removeFromSuperview];
//    [self.groupsVC.view removeFromSuperview];
//    [self.view addSubview:self.allEventsVC.view];
//    [self.view addSubview:self.groupsVC.view];
    
    if(self.profileVC){
        self.profileVC.view.frame = CGRectOffset(self.profileVC.view.frame, -640, 0);
    }
    if(self.pollVC){
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, -640, 0);
    }
    self.contactsVC.view.frame = CGRectOffset(self.contactsVC.view.frame, -640, 0);
    self.allEventsVC.view.frame = CGRectOffset(self.allEventsVC.view.frame, -640, 0);

    self.contactsVisible = NO;
}

#pragma mark - Contact Delegate

-(void)didSelectContact:(CKUser *)selectedContact{
    
    [self addChildViewController:self.profileVC];
    [self.profileVC didMoveToParentViewController:self];
    [self.view addSubview:self.profileVC.view];
    
    [self.profileVC loadSelectedContact:selectedContact];
    
    [UIView animateWithDuration:.4 animations:^{
        self.profileVC.view.frame = self.view.frame;
        self.contactsVC.view.frame = CGRectOffset(self.contactsVC.view.frame, 240, 0);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.groupsVC.view];
    }];
}

#pragma mark - Profile Delegate

-(void)didSelectProfileExit{
    [UIView animateWithDuration:.4 animations:^{
        self.profileVC.view.frame = CGRectOffset(self.profileVC.view.frame, -240, 0);
        self.contactsVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.profileVC removeFromParentViewController];
        [self.profileVC.view removeFromSuperview];
        self.profileVC = nil;
    }];
}

#pragma mark - All Events Delegate

-(void)didSelectPoll:(CKEvent *)selectedPoll{
    
    [self addChildViewController:self.pollVC];
    [self.pollVC didMoveToParentViewController:self];
    [self.view addSubview:self.pollVC.view];
    
    [self.pollVC loadSelectedPoll:selectedPoll];
    
    [UIView animateWithDuration:.4 animations:^{
        self.pollVC.view.frame = self.view.frame;
        self.allEventsVC.view.frame = CGRectOffset(self.allEventsVC.view.frame, -240, 0);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.groupsVC.view];
    }];
}

#pragma mark - Poll Delegate

-(void)didSelectPollExit{
    [UIView animateWithDuration:.4 animations:^{
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, 240, 0);
        self.allEventsVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.pollVC removeFromParentViewController];
        [self.pollVC.view removeFromSuperview];
        self.pollVC = nil;
    }];
}

#pragma mark - Lazy

-(CKAllEventsVC *)allEventsVC{
    if(!_allEventsVC){
        _allEventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"allEventsVC"];
        _allEventsVC.view.frame = CGRectOffset(self.view.frame, 640, 0);
        _allEventsVC.delegate = self;
    }
    return _allEventsVC;
}

-(CKGroupVC *)groupsVC{
    if(!_groupsVC){
        
        _groupsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupsVC"];
        _groupsVC.view.frame = self.view.frame;
        [_groupsVC configureParentDelegate:self];
    }
    return _groupsVC;
}

-(CKContactsVC *)contactsVC {
    if(!_contactsVC){
        _contactsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contactsVC"];
        _contactsVC.view.frame = self.view.frame;
        _contactsVC.delegate = self;
    }
    return _contactsVC;
}

-(CKProfileVC *)profileVC {
    if(!_profileVC){
        _profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        _profileVC.view.frame = CGRectOffset(self.contactsVC.view.frame, -240, 0);
        _profileVC.delegate = self;
    }
    return _profileVC;
}

-(CKPollVC *)pollVC {
    if(!_pollVC){
        _pollVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pollVC"];
        _pollVC.view.frame = CGRectOffset(self.allEventsVC.view.frame, 240, 0);
        _pollVC.delegate = self;
    }
    return _pollVC;
}


#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
