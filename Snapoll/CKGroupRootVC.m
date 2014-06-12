//
//  CKGroupRootVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupRootVC.h"
#import "CKGroupMemberTableVC.h"
#import "CKGroupEventsVC.h"
#import "CKChatVC.h"

@interface CKGroupRootVC () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CKGroupMemberTableVC *groupMemberVC;
@property (strong, nonatomic) CKGroupEventsVC *groupEventsVC;
@property (strong, nonatomic) CKChatVC *chatVC;

@property (nonatomic, getter = isMenuOpen) BOOL menuOpen;
@property (nonatomic, getter = isMembersVisible) BOOL membersVisible;

@end

@implementation CKGroupRootVC

#pragma mark - Views

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self configureChildVCs];
    
    [self setupPanGesture];
}

#pragma mark - Configure and Setup Functions

-(void)configureChildVCs{
    
    [self addChildViewController:self.groupMemberVC];
    [self.groupMemberVC didMoveToParentViewController:self];
    [self.view addSubview:self.groupMemberVC.view];
    
    [self addChildViewController:self.groupEventsVC];
    [self.groupEventsVC didMoveToParentViewController:self];
    [self.view addSubview:self.groupEventsVC.view];
    
    [self addChildViewController:self.chatVC];
    [self.chatVC didMoveToParentViewController:self];
    [self.view addSubview:self.chatVC.view];
    
    self.membersVisible = NO;
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
               self.chatVC.view.frame.origin.x+viewTranslation.x<= self.chatVC.view.frame.size.width*.8)
            {
                if (!self.isMembersVisible) { [self makeContactsVCVisible]; }
                
                self.chatVC.view.center = CGPointMake(self.chatVC.view.center.x+viewTranslation.x, self.chatVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                // Open Menu Right
            } else if (self.chatVC.view.frame.origin.x+viewTranslation.x<0 &&
                       self.chatVC.view.frame.origin.x+viewTranslation.x>= -self.chatVC.view.frame.size.width*.8)
            {
                if (self.isMembersVisible) { [self makeAllEventsVCVisible]; }
                
                self.chatVC.view.center = CGPointMake(self.chatVC.view.center.x+viewTranslation.x, self.chatVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            if(self.chatVC.view.frame.origin.x > self.view.frame.size.width/4){
                [self openLeftMenu];
            } else if(self.chatVC.view.frame.origin.x < -self.view.frame.size.width/4){
                [self openRightMenu];
            } else if (self.chatVC.view.frame.origin.x < self.view.frame.size.width/2){
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
     //   [self.delegate didMenuOpen:YES];
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
     //   [self.delegate didMenuOpen:YES];
    }];
}

-(void) closeMenu{
    [self.chatVC.view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.4 animations:^{
        self.chatVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.menuOpen = NO;
       // [self.delegate didMenuOpen:NO];
    }];
}

-(void) makeContactsVCVisible{
    //    [self.contactsVC.view removeFromSuperview];
    //    [self.groupsVC.view removeFromSuperview];
    //    [self.view addSubview:self.contactsVC.view];
    //    [self.view addSubview:self.groupsVC.view];
    
    [self.view bringSubviewToFront:self.groupMemberVC.view];
    [self.view bringSubviewToFront:self.chatVC.view];
    
    self.membersVisible = YES;
}

-(void) makeAllEventsVCVisible{
    //    [self.allEventsVC.view removeFromSuperview];
    //    [self.groupsVC.view removeFromSuperview];
    //    [self.view addSubview:self.allEventsVC.view];
    //    [self.view addSubview:self.groupsVC.view];
    
    [self.view bringSubviewToFront:self.groupEventsVC.view];
    [self.view bringSubviewToFront:self.chatVC.view];
    
    self.membersVisible = NO;
}

#pragma mark - Lazy

-(CKGroupEventsVC *)groupEventsVC{
    if(!_groupEventsVC){
        _groupEventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupEventsVC"];
        _groupEventsVC.view.frame = self.view.frame;
    }
    return _groupEventsVC;
}

-(CKChatVC*)chatVC{
    if(!_chatVC){
        _chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
        _chatVC.view.frame = self.view.frame;
       // [_groupsVC configureParentDelegate:self];
    }
    return _chatVC;
}

-(CKGroupMemberTableVC *)groupMemberVC {
    if(!_groupMemberVC){
        _groupMemberVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupMemberVC"];
        _groupMemberVC.view.frame = self.view.frame;
    }
    return _groupMemberVC;
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end