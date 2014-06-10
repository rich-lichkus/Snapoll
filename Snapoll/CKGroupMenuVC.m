//
//  CKGroupMenuVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/29/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupMenuVC.h"

@interface CKGroupMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL menuOpen;
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (strong, nonatomic) CKUser *currentUser;


@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnCredits;
@property (strong, nonatomic) IBOutlet UIButton *btnMyAccount;

@property (strong, nonatomic) UIBarButtonItem *btnAddGroup;
@property (strong, nonatomic) UIBarButtonItem *btnAddContact;

- (IBAction)pressedMyAccount:(id)sender;
- (IBAction)pressedGroups:(id)sender;
- (IBAction)pressedContacts:(id)sender;
- (IBAction)pressedLogout:(id)sender;
- (IBAction)pressedCredits:(id)sender;
- (IBAction)pressedMenu:(id)sender;
- (IBAction)pressedAddNewGroup:(id)sender;

@end

@implementation CKGroupMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Loads

-(void) viewWillAppear:(BOOL)animated{
    
    [self parseUpdateContacts];
    
    [self.tblContacts reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Groups";
    
    self.btnAddGroup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    
    self.btnAddContact = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact:)];
    
    self.navigationItem.rightBarButtonItem = self.btnAddGroup;
    
    // Configure Child VCs
    self.groupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupVC"];
    [self addChildViewController:self.groupVC];
    self.groupVC.view.frame = self.view.frame;
    [self.groupVC didMoveToParentViewController:self];
    
    self.contactsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contactsVC"];
    [self addChildViewController:self.contactsVC];
    self.contactsVC.view.frame = self.view.frame;
    [self.contactsVC didMoveToParentViewController:self];
    
    self.profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    [self addChildViewController:self.profileVC];
    self.profileVC.view.frame = self.view.frame;
    [self.profileVC didMoveToParentViewController:self];
    
    self.topVC = self.groupVC;
    [self.view addSubview:self.topVC.view];
    
    // Configure Menu Animations
    self.menuOpen = NO;
    [self setupPanGesture];

//  Configure Dynamic Menu Options
//  self.lblFirstName.text = self.groupVC.currentUser.firstName;

    self.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.layer.frame.size.width/2;
    NSLog(@"%f",self.imgAvatar.image.size.width);
    self.imgAvatar.layer.masksToBounds = YES;
    
    self.tblContacts.delegate = self;
    self.tblContacts.dataSource = self;
    
}

#pragma mark - Table

//    cell.imageView.alpha = .5;
//    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x,
//                                      cell.imageView.frame.origin.y,
//                                      cell.imageView.frame.size.width-50,
//                                      cell.imageView.frame.size.height-50);


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentUser.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    CKUser *currentContact = self.currentUser.contacts[indexPath.row];
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = [[[currentContact firstName] stringByAppendingString: @" " ] stringByAppendingString: currentContact.lastName];
    cell.detailTextLabel.text = [@"$" stringByAppendingString: [currentContact userName]];
    
    return cell;
}

#pragma mark - Slide Gesture

-(void)setupPanGesture{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];

    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    
    panGesture.delegate = self;
    panGesture.delaysTouchesBegan = YES;
    panGesture.delaysTouchesEnded = YES;
    
    [self.view addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    CGPoint point = [touch locationInView:self.groupVC.view];
    
    if ((point.x >=0 && point.x <=30) || (point.x <=320 && point.x >=290)){
        return YES;
    } else {
        return NO;
    }
}

-(void)slidePanel:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    
    CGPoint viewTranslation = [panGesture translationInView:self.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
            
                if(self.topVC.view.frame.origin.x+viewTranslation.x>=0 &&
                   self.topVC.view.frame.origin.x+viewTranslation.x<= self.topVC.view.frame.size.width*.5)
                {
                    self.topVC.view.center = CGPointMake(self.topVC.view.center.x+viewTranslation.x, self.topVC.view.center.y);
                    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                    
                } else if (self.topVC.view.frame.origin.x+viewTranslation.x<0 &&
                           self.topVC.view.frame.origin.x+viewTranslation.x>= -self.topVC.view.frame.size.width*.5)
                {
                    self.topVC.view.center = CGPointMake(self.topVC.view.center.x+viewTranslation.x, self.topVC.view.center.y);
                    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
                }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
                if(self.topVC.view.frame.origin.x > self.view.frame.size.width/4){
                    [self openMenu];
                } else if(self.topVC.view.frame.origin.x < -self.view.frame.size.width/4){
                    [self openRightMenu];
                } else if (self.topVC.view.frame.origin.x < self.view.frame.size.width/2){
                    [self closeMenu];
                }
            
            break;
    }
}

-(void) openRightMenu{
    [self.topVC.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.4 animations:^{
        self.topVC.view.frame = CGRectMake(-self.view.frame.size.width*.5,
                                           self.topVC.view.frame.origin.y,
                                           self.topVC.view.frame.size.width,
                                           self.topVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) openMenu{
    [self.topVC.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.4 animations:^{
        self.topVC.view.frame = CGRectMake(self.view.frame.size.width*.5,
                                             self.topVC.view.frame.origin.y,
                                             self.topVC.view.frame.size.width,
                                             self.topVC.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) closeMenu{
    [self.topVC.view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.4 animations:^{
        self.topVC.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - Selector
- (void)addGroup:(id)sender {
    [self performSegueWithIdentifier:@"toAddGroupVC" sender:nil];
}

- (void)addContact:(id)sender {
    [self performSegueWithIdentifier:@"toAddContactVC" sender:nil];
}

#pragma mark - Buttons

- (IBAction)pressedMyAccount:(id)sender {
    self.profileVC.view.frame = self.topVC.view.frame;
    [self.topVC.view removeFromSuperview];
    self.topVC = self.profileVC;
    [self.view addSubview:self.topVC.view];
    [self setupPanGesture];
    self.menuOpen = NO;
    [self closeMenu];
    self.title = @"Profile";
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)pressedGroups:(id)sender {
    self.groupVC.view.frame = self.topVC.view.frame;
    [self.topVC.view removeFromSuperview];
    self.topVC = self.groupVC;
    [self.view addSubview:self.topVC.view];
    [self setupPanGesture];
    self.menuOpen = NO;
    [self closeMenu];
    self.title = @"My Groups";
    self.navigationItem.rightBarButtonItem = self.btnAddGroup;
}

- (IBAction)pressedContacts:(id)sender {
    self.contactsVC.view.frame = self.topVC.view.frame;
    [self.topVC.view removeFromSuperview];
    self.topVC = self.contactsVC;
    [self.view addSubview:self.topVC.view];
    [self setupPanGesture];
    self.menuOpen = NO;
    [self closeMenu];
    self.title = @"Contacts";
    self.navigationItem.rightBarButtonItem = self.btnAddContact;
}

- (IBAction)pressedLogout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLoginVC" sender:nil];
}

- (IBAction)pressedCredits:(id)sender {
    
}

- (IBAction)pressedMenu:(id)sender {
    if(self.menuOpen){
        [self closeMenu];
        self.menuOpen = NO;
    } else {
        [self openMenu];
        self.menuOpen = YES;
    }
}

- (IBAction)pressedAddNewGroup:(id)sender {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Parse

-(void)parseUpdateContacts{
    
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    [CKNetworkHelper parseRetrieveContacts:self.currentUser.userID WithCompletion:^(NSError *error) {
        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tblContacts reloadData];
        }];
    }];
    
    //    [CKNetworkHelper parseRetrieveContactRequests:self.currentUser.userID withCompletion:^(NSError *error){
    //
    //    }];
}


#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
