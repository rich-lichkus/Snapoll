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

@interface CKHotBoxRootVC () <UIGestureRecognizerDelegate>

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
    
    self.contactsVisible = NO;
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
               self.groupsVC.view.frame.origin.x+viewTranslation.x<= self.groupsVC.view.frame.size.width*.8)
            {
                if (!self.isContactsVisible) { [self makeContactsVCVisible]; }

                self.groupsVC.view.center = CGPointMake(self.groupsVC.view.center.x+viewTranslation.x, self.groupsVC.view.center.y);
                [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
            // Open Menu Right
            } else if (self.groupsVC.view.frame.origin.x+viewTranslation.x<0 &&
                       self.groupsVC.view.frame.origin.x+viewTranslation.x>= -self.groupsVC.view.frame.size.width*.8)
            {
                if (self.isContactsVisible) { [self makeAllEventsVCVisible]; }
                
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
    
    [self.view bringSubviewToFront:self.contactsVC.view];
    [self.view bringSubviewToFront:self.groupsVC.view];
    
    self.contactsVisible = YES;
}

-(void) makeAllEventsVCVisible{
//    [self.allEventsVC.view removeFromSuperview];
//    [self.groupsVC.view removeFromSuperview];
//    [self.view addSubview:self.allEventsVC.view];
//    [self.view addSubview:self.groupsVC.view];
    
    [self.view bringSubviewToFront:self.allEventsVC.view];
    [self.view bringSubviewToFront:self.groupsVC.view];
    
    self.contactsVisible = NO;
}

#pragma mark - Lazy

-(CKAllEventsVC *)allEventsVC{
    if(!_allEventsVC){
        _allEventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"allEventsVC"];
        _allEventsVC.view.frame = self.view.frame;
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
    }
    return _contactsVC;
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end