//
//  CKNewMemberVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 5/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKNewMemberVC.h"

@interface CKNewMemberVC ()

@property (strong, nonatomic) IBOutlet UISearchBar *sbrUsers;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segContactLists;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (strong, nonatomic) IBOutlet UITableView *tblUserList;
- (IBAction)pressedCancel:(id)sender;
- (IBAction)pressedDone:(id)sender;

@property (strong, nonatomic) CKUser *currentUser;
@property (strong, nonatomic) NSMutableArray *selectedContacts;

@end

@implementation CKNewMemberVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self parseGetContactList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tblUserList.delegate = self;
    self.tblUserList.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentUser.contacts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKAddContactsTVCell *cell = [self.tblUserList dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    CKUser *currentMember = self.currentUser.contacts[indexPath.row];
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.image = [UIImage imageNamed:@"907-plus-rounded-square-1"];
//    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
//    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = [[[currentMember firstName] stringByAppendingString: @" "] stringByAppendingString: currentMember.lastName];
    cell.detailTextLabel.text = [@"$" stringByAppendingString: [currentMember userName]];
    
    CKUser *exitingMember = [self.selectedGroup getMemberWithId:currentMember.userID];
    PFUser *invitedMember = [self.selectedGroup getPendingMemberWithId:currentMember.userID];
    
    if(exitingMember || invitedMember){
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    if(exitingMember){
        cell.imageView.image = [UIImage imageNamed:@"silver-plus-rounded-square-selected"];
    }
    
    if(invitedMember){
        cell.imageView.image = [UIImage imageNamed:@"message-512"];
    }
    
    exitingMember = nil;
    invitedMember = nil;
    return cell;
}

#pragma mark - Selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CKAddContactsTVCell *selectedCell = (CKAddContactsTVCell*)[self.tblUserList cellForRowAtIndexPath:indexPath];

    CKUser *exitingMember = [self.selectedGroup getMemberWithId:[self.currentUser.contacts[indexPath.row] userID]];
    
    if(!exitingMember){
        if(selectedCell.cellSelected == NO){
            [self.tblUserList deselectRowAtIndexPath:indexPath animated:YES];
            selectedCell.cellSelected = YES;
            selectedCell.imageView.image = [UIImage imageNamed:@"907-plus-rounded-square-selected"];
            if(![self.selectedContacts containsObject:self.currentUser.contacts[indexPath.row]]){
                [self.selectedContacts  addObject:self.currentUser.contacts[indexPath.row]];
            }
        } else{
            [self.tblUserList deselectRowAtIndexPath:indexPath animated:YES];
            selectedCell.cellSelected = NO;
            selectedCell.imageView.image = [UIImage imageNamed:@"907-plus-rounded-square-1"];
            if(![self.selectedContacts containsObject:self.currentUser.contacts[indexPath.row]]){
                [self.selectedContacts  removeObject:self.currentUser.contacts[indexPath.row]];
            }
        }
    }
    exitingMember = nil;
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

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)pressedDone:(id)sender {
    // Invite selectedContacts to Group Members
    
    PFQuery *pfGroupQuery = [PFQuery queryWithClassName:@"Group"];
    [pfGroupQuery whereKey:@"objectId" equalTo:self.selectedGroup.groupID];
    [pfGroupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *groupObject = objects[0];
//        for(CKUser *newMemeber in self.selectedContacts){
        CKUser *newMember = self.selectedContacts[0];
        
            PFQuery *getContact = [PFQuery queryWithClassName:@"_User"];
            [getContact whereKey:@"objectId" equalTo:newMember.userID];
            [getContact findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
               
                PFUser *selectedUser = objects[0];
                
                PFObject *groupInvitation = [PFObject objectWithClassName:@"GroupInvitations"];
                groupInvitation[@"fromID"] = [PFUser currentUser].objectId;
                groupInvitation[@"toID"] = selectedUser.objectId;
                groupInvitation[@"groupName"] = self.selectedGroup.groupName;
                groupInvitation[@"groupID"] = groupObject.objectId;
                
                [groupInvitation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
                
            }];
    }];
}

#pragma mark - Network

-(void)parseGetContactList{
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
//    [CKNetworkHelper parseRetrieveContacts:self.currentUser.userID WithCompletion:^(NSError *error) {
//        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.tblUserList reloadData];
//        }];
//    }];
}

#pragma mark - Lazy

-(NSMutableArray*)selectedContacts{
    if(!_selectedContacts){
        _selectedContacts = [[NSMutableArray alloc] init];
    }
    return _selectedContacts;
}



@end
