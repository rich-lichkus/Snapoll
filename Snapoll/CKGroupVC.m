//
//  CKGroupVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/21/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupVC.h"
#import "CKGroupMemberTableVC.h"
#import "CKHotBoxRootVC.h"

@interface CKGroupVC () <CKHotBoxRootVCDelegate>

@property (weak, nonatomic) CKHotBoxRootVC *parentVC;
@property (strong, nonatomic) IBOutlet UITableView *tblGroup;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) CKUser *currentUser;

@property (nonatomic, getter = isMenuOpen) BOOL menuOpen;

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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Delegate

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
            [CKArchiverHelper saveUserDataToArchive];
            [self.tblGroup deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
