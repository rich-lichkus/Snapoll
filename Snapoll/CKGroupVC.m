//
//  CKGroupVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupVC.h"
#import "CKHotBoxRootVC.h"
#import "CKChatVC.h"
#import "PaintCodeImages.h"

@interface CKGroupVC () <CKHotBoxRootVCDelegate>

@property (weak, nonatomic) CKHotBoxRootVC *parentVC;
@property (strong, nonatomic) IBOutlet UITableView *tblGroup;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) CKUser *currentUser;
@property (nonatomic, getter = isMenuOpen) BOOL menuOpen;

@property (weak, nonatomic) IBOutlet UIView *uivNewGroup;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCreateOption;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (strong, nonatomic) UIBarButtonItem *bbiAddGroup;
@property (strong, nonatomic) UIBarButtonItem *bbiCurrentUser;

- (IBAction)segValueChanged:(id)sender;

@end

@implementation CKGroupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self parseUpdateGroups];
    
    [self.tblGroup reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication] delegate]).currentUser;
    
    [self configureTable];
    
    [self configureSubviews];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Configure Delegate

-(void)configureParentDelegate:(CKHotBoxRootVC *)parentVC{
    self.parentVC = parentVC;
    self.parentVC.delegate = self;
}

-(void)didMenuOpen:(BOOL)isOpen{
    self.menuOpen = isOpen;
    [self.tblGroup setEditing:NO];
    [self.tblGroup setScrollEnabled:!self.menuOpen];
    self.tblGroup.allowsSelection = !self.menuOpen;
   
}

-(void)configureSubviews{
    self.uivNewGroup.hidden = YES;
    self.bbiAddGroup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressedAddGroup:)];
    
    self.bbiCurrentUser = [[UIBarButtonItem alloc]initWithImage:[PaintCodeImages imageOfBBPlaceholderAvatar]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(pressedCurrentUserBarButton:)];
    
    self.txtGroupName.placeholder = @"New Group Name";
    self.navBar.topItem.leftBarButtonItem = self.bbiCurrentUser;
    self.navBar.topItem.rightBarButtonItem = self.bbiAddGroup;
}

#pragma mark - Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.currentUser.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupsCell"];
    
    cell.textLabel.text = [self.currentUser.groups[indexPath.row] groupName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath  {

    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        NSString *groupID = [self.currentUser.groups[indexPath.row] groupID];
        
        [CKNetworkHelper deleteGroupWithId:groupID withCompletion:^{
            [self.currentUser.groups removeObjectAtIndex:indexPath.row];
            //[CKArchiverHelper saveUserDataToArchive];
            [self.tblGroup deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Actions

- (IBAction)pressedAddGroup:(id)sender {
    
    self.tblGroup.frame = CGRectMake(self.tblGroup.frame.origin.x,
                                     self.tblGroup.frame.origin.y,
                                     self.tblGroup.frame.size.width,
                                     self.tblGroup.frame.size.height-40);
    
    [UIView animateWithDuration:.3 animations:^{
        self.tblGroup.frame = CGRectOffset(self.tblGroup.frame, 0, 40);
        self.uivNewGroup.frame = CGRectOffset(self.uivNewGroup.frame, 0, 38);
        self.uivNewGroup.hidden = NO;
    } completion:^(BOOL finished) {

    }];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pressedCancel)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pressedDone)];
    self.navBar.topItem.leftBarButtonItem = cancelButton;
    self.navBar.topItem.rightBarButtonItem = doneButton;
}

-(void)pressedCurrentUserBarButton:(id)sender{
    
    //
    //self.parentVC.
    // Load detail contact page, with current user
    // Open left menu

}

-(void)pressedCancel{
    [self closeNewGroupView];
    [self.txtGroupName resignFirstResponder];
}

-(void)pressedDone{
    
    if(self.txtGroupName.text.length >0) {
        switch (self.segCreateOption.selectedSegmentIndex) {
            case 0: { // Create New Group
                [PFCloud callFunctionInBackground:@"createNewGroup"
                                   withParameters:@{@"groupName": self.txtGroupName.text}
                                            block:^(id object, NSError *error) {
                                                //[self closeNewGroupView];
                                            }];
            }
                break;
                
            case 1: { // Join Group
                [PFCloud callFunctionInBackground:@"joinGroup"
                                   withParameters:@{@"objectId" : self.txtGroupName.text }
                                            block:^(id object, NSError *error) {
                                                [self closeNewGroupView];
                                            }];
            }
                break;
        }
    }
}

- (IBAction)segValueChanged:(id)sender {
    
    switch (self.segCreateOption.selectedSegmentIndex) {
        case 0: // New
            self.txtGroupName.placeholder = @"New Group Name";
            break;
            
        case 1: // Join
            self.txtGroupName.placeholder = @"Group ID";
            break;
    }
}

#pragma mark - Animated Views

-(void) closeNewGroupView {
    self.navBar.topItem.leftBarButtonItem = self.bbiCurrentUser;
    self.navBar.topItem.rightBarButtonItem = self.bbiAddGroup;
    
    self.tblGroup.frame = CGRectMake(self.tblGroup.frame.origin.x,
                                     self.tblGroup.frame.origin.y,
                                     self.tblGroup.frame.size.width,
                                     self.tblGroup.frame.size.height+40);
    
    [UIView animateWithDuration:.3 animations:^{
        self.tblGroup.frame = CGRectOffset(self.tblGroup.frame, 0, -40);
        self.uivNewGroup.frame = CGRectOffset(self.uivNewGroup.frame, 0, -38);
    } completion:^(BOOL finished) {
        self.uivNewGroup.hidden = YES;
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedPath = [self.tblGroup indexPathForSelectedRow];
    
    // CKChat Tab VC Properties
//    CKChatVC *chatViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
//    chatViewController.selectedGroup = self.currentUser.groups[selectedPath.row];
//    chatViewController.title = [self.currentUser.groups[selectedPath.row] groupName];
    
    // UITabBarController Properties
//    UITabBarController *tabVC = segue.destinationViewController;
//    tabVC.title = [self.currentUser.groups[selectedPath.row] groupName];
    
    // CKMember Tab VC Properties
//    CKGroupMemberTableVC *memberViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:1];
//    memberViewController.selectedGroup = self.currentUser.groups[selectedPath.row];
    
    CKGroupRootVC *groupRootVC = [segue destinationViewController];
    groupRootVC.selectedGroup = self.currentUser.groups[selectedPath.row];
    NSLog(@"Prepare for segue");
}

#pragma mark - Parse 

-(void)parseUpdateGroups{
    // Query and download user's groups
    [CKNetworkHelper parseRetrieveGroupsWithCompletion:^(NSError *error) {
        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tblGroup reloadData];
        }];
    }];
}

#pragma mark - Configure

-(void)configureTable{
    self.tblGroup.delegate = self;
    self.tblGroup.dataSource = self;
    //self.tblGroup.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
