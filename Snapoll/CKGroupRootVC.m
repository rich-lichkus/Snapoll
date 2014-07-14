//
//  CKGroupRootVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupRootVC.h"
#import "CKGroupMemberVC.h"
#import "CKGroupEventsVC.h"
#import "CKProfileVC.h"
#import "CKNetworkHelper.h"
#import "CKPollVC.h"

@interface CKGroupRootVC () <UIGestureRecognizerDelegate, CKGroupEventsVCDelegate, CKPollVCDelegate>

@property (strong, nonatomic) CKProfileVC *profileVC;
@property (strong, nonatomic) CKGroupMemberVC *groupMemberVC;
@property (strong, nonatomic) CKGroupEventsVC *groupEventsVC;
@property (strong, nonatomic) CKPollVC *pollVC;
@property (strong, nonatomic) NSString *groupMessageName;

@property (nonatomic, getter = isMenuOpen) BOOL menuOpen;
@property (nonatomic, getter = isMembersVisible) BOOL membersVisible;

@end

@implementation CKGroupRootVC

#pragma mark - Views

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self configureChildVCs];

    [self setupPanGesture];
    
    [self setupParse];
}

#pragma mark - Configure and Setup Functions

-(void)configureChildVCs{
    
    [self addChildViewController:self.groupMemberVC];
    [self.groupMemberVC didMoveToParentViewController:self];
    [self.view addSubview:self.groupMemberVC.view];
    self.groupMemberVC.parentVC = self;
    
    [self addChildViewController:self.groupEventsVC];
    [self.groupEventsVC didMoveToParentViewController:self];
    [self.view addSubview:self.groupEventsVC.view];
    
    [self addChildViewController:self.chatVC];
    [self.chatVC didMoveToParentViewController:self];
    [self.view addSubview:self.chatVC.view];
    
    self.membersVisible = YES;
}

-(void)setupPanGesture{
    
    self.menuOpen = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    
    panGesture.delegate = self;
    panGesture.delaysTouchesBegan = YES;
    panGesture.delaysTouchesEnded = YES;
    
    [self.chatVC.view addGestureRecognizer:panGesture];
}

#pragma mark - Parse

-(void)setupParse {

    // Retrieve Group's Memebers
    [CKNetworkHelper parseRetrieveGroupMembers:self.selectedGroup.groupID WithCompletion:^(NSError *error) {
        [self.groupMemberVC.tblGroupMember reloadData];
    }];
    
    // Retrieve Group's Messages
    self.groupMessageName = [@"message_" stringByAppendingString:self.selectedGroup.groupName];
    [CKNetworkHelper parseRetrieveMessageForGroupId:self.selectedGroup.groupID withCompletion:^(NSError *error) {
        [self.chatVC.tblMessages reloadData];
        [self.chatVC scrollTableAnimated:NO];
        NSLog(@"group root done.");
    }];
    
    // Retrieve Group's Polls
    // Retrieve Group's Events
}

#pragma mark - Slide Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point = [touch locationInView:self.chatVC.view];
    
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
    
    CGPoint viewTranslation = [panGesture translationInView:self.chatVC.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
            // Open Menu Left
            if(self.chatVC.view.frame.origin.x+viewTranslation.x>=0 &&
               self.chatVC.view.frame.origin.x+viewTranslation.x<= self.chatVC.view.frame.size.width*.75)
            {
                if (!self.isMembersVisible) {
                    [self makeContactsVCVisible];
                }
                
                self.chatVC.view.center = CGPointMake(self.chatVC.view.center.x+viewTranslation.x, self.chatVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                // Open Menu Right
            } else if (self.chatVC.view.frame.origin.x+viewTranslation.x<0 &&
                       self.chatVC.view.frame.origin.x+viewTranslation.x>= -self.chatVC.view.frame.size.width*.75)
            {
                if (self.isMembersVisible) {
                    [self makeAllEventsVCVisible];
                }
                
                self.chatVC.view.center = CGPointMake(self.chatVC.view.center.x+viewTranslation.x, self.chatVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            if(self.chatVC.view.frame.origin.x > self.view.frame.size.width*.25){
                [self openLeftMenu];
            } else if(self.chatVC.view.frame.origin.x < -self.view.frame.size.width*.25){
                [self openRightMenu];
            } else if (self.chatVC.view.frame.origin.x < self.view.frame.size.width*.5){
                [self closeMenu];
            }
            
            break;
    }
}

-(void) openRightMenu{
    [UIView animateWithDuration:.4 animations:^{
        self.chatVC.view.frame = CGRectMake(-self.view.frame.size.width*.75,
                                              self.chatVC.view.frame.origin.y,
                                              self.chatVC.view.frame.size.width,
                                              self.chatVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuOpen = YES;
        [self.delegate didMenuOpen:YES];
    }];
}

-(void) openLeftMenu{
    [UIView animateWithDuration:.4 animations:^{
        self.chatVC.view.frame = CGRectMake(self.view.frame.size.width*.75,
                                              self.chatVC.view.frame.origin.y,
                                              self.chatVC.view.frame.size.width,
                                              self.chatVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.menuOpen = YES;
        [self.delegate didMenuOpen:YES];
    }];
}

-(void) closeMenu{
    [self.chatVC.view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.4 animations:^{
        self.chatVC.view.frame = self.view.frame;
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
    
//    [self.view bringSubviewToFront:self.groupMemberVC.view];
//    [self.view bringSubviewToFront:self.chatVC.view];
    
    if(self.pollVC){
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, -640, 0);
    }
    self.groupMemberVC.view.frame = CGRectOffset(self.groupMemberVC.view.frame, 640, 0);
    self.groupEventsVC.view.frame = CGRectOffset(self.groupEventsVC.view.frame, 640, 0);
    
    self.membersVisible = YES;
}

-(void) makeAllEventsVCVisible{
    //    [self.allEventsVC.view removeFromSuperview];
    //    [self.groupsVC.view removeFromSuperview];
    //    [self.view addSubview:self.allEventsVC.view];
    //    [self.view addSubview:self.groupsVC.view];
    
//    [self.view bringSubviewToFront:self.groupEventsVC.view];
//    [self.view bringSubviewToFront:self.chatVC.view];

    if(self.pollVC){
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, 640, 0);
    }
    self.groupMemberVC.view.frame = CGRectOffset(self.groupMemberVC.view.frame, -640, 0);
    self.groupEventsVC.view.frame = CGRectOffset(self.groupEventsVC.view.frame, -640, 0);
    
    self.membersVisible = NO;
}

#pragma mark - Contact Delegate

-(void)didSelectContact:(CKUser *)selectedContact{
    [self addChildViewController:self.profileVC];
    [self.profileVC didMoveToParentViewController:self];
    [self.view addSubview:self.profileVC.view];
    
    [self.profileVC loadSelectedContact:selectedContact];
    
    [UIView animateWithDuration:.4 animations:^{
        self.profileVC.view.frame = self.view.frame;
        self.groupMemberVC.view.frame = CGRectOffset(self.groupMemberVC.view.frame, 240, 0);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.chatVC.view];
    }];
}

#pragma mark - Profile Delegate

-(void)didSelectProfileExit{
    [UIView animateWithDuration:.4 animations:^{
        self.profileVC.view.frame = CGRectOffset(self.profileVC.view.frame, -240, 0);
        self.groupMemberVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.profileVC removeFromParentViewController];
        [self.profileVC.view removeFromSuperview];
        self.profileVC = nil;
    }];
}

#pragma mark - GroupEvents Delegate

-(void)didSelectPoll:(CKEvent *)selectedPoll{
    
    [self addChildViewController:self.pollVC];
    [self.pollVC didMoveToParentViewController:self];
    [self.view addSubview:self.pollVC.view];
    
    [self.pollVC loadSelectedPoll:selectedPoll];
    
    [UIView animateWithDuration:.4 animations:^{
        self.pollVC.view.frame = self.view.frame;
        self.groupEventsVC.view.frame = CGRectOffset(self.groupEventsVC.view.frame, -240, 0);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.chatVC.view];
    }];
}

#pragma mark - Poll Delegate

-(void)didSelectPollExit{
    [UIView animateWithDuration:.4 animations:^{
        self.pollVC.view.frame = CGRectOffset(self.pollVC.view.frame, 240, 0);
        self.groupEventsVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.pollVC removeFromParentViewController];
        [self.pollVC.view removeFromSuperview];
        self.pollVC = nil;
    }];
}

#pragma mark - Lazy

-(CKGroupEventsVC *)groupEventsVC{
    if(!_groupEventsVC){
        _groupEventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupEventsVC"];
        _groupEventsVC.view.frame = CGRectOffset(self.view.frame, 640, 0);
        _groupEventsVC.delegate = self;
    }
    return _groupEventsVC;
}

-(CKChatVC*)chatVC{
    if(!_chatVC){
        _chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
        _chatVC.view.frame = self.view.frame;
       [_chatVC configureParentDelegate:self];
    }
    return _chatVC;
}

-(CKGroupMemberVC *)groupMemberVC {
    if(!_groupMemberVC){
        _groupMemberVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupMemberVC"];
        _groupMemberVC.view.frame = self.view.frame;
        [_chatVC configureParentDelegate:self];
    }
    return _groupMemberVC;
}

-(CKProfileVC *)profileVC {
    if(!_profileVC){
        _profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        _profileVC.view.frame = CGRectOffset(self.groupMemberVC.view.frame, -240, 0);
        _profileVC.delegate = self;
    }
    return _profileVC;
}

-(CKPollVC *)pollVC {
    if(!_pollVC){
        _pollVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pollVC"];
        _pollVC.view.frame = CGRectOffset(self.groupEventsVC.view.frame, 240, 0);
        _pollVC.delegate = self;
    }
    return _pollVC;
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
