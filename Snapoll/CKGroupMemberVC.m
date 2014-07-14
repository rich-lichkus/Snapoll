//
//  CKGroupMemberVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupMemberVC.h"
#import "CKContactsCell.h"
#import "CKGroupRootVC.h"

@interface CKGroupMemberVC() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CKUser *currentUser;
@property (strong, nonatomic) NSMutableArray *memberSearchResults;

@end

@implementation CKGroupMemberVC

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTables];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Configure and setup functions

-(void)configureTables{
    self.tblGroupMember.delegate = self;
    self.tblGroupMember.dataSource = self;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = 0;
    
    if (self.memberSearchResults){
        numSections = 1;
    } else {
        numSections = 2; // Contacts, Outgoing
    }
    
    return numSections;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *title;
//    switch (section) {
//        case 0:
//            title = @"Members";
//            break;
//        case 1:
//            title = @"Invites";
//            break;
//    }
//    return title;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    if (self.memberSearchResults){
        numRows = self.memberSearchResults.count;
    } else {
        switch (section) {
            case 0:
                numRows = self.parentVC.selectedGroup.members.count;
                break;
            case 1:
                numRows = self.parentVC.selectedGroup.outgoingGroupRequests.count;
                break;
        }
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
    
    CKUser *currentMember;
    
    if (self.memberSearchResults) {
        currentMember  = self.memberSearchResults[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: {
                currentMember  = self.parentVC.selectedGroup.members[indexPath.row];
            }
                break;
            case 1: {
                currentMember = self.parentVC.selectedGroup.outgoingGroupRequests[indexPath.row];
            }
                break;
        }
    }
    
    [self configureTableCell:cell WithContact:currentMember];
    
    return cell;
}

-(void)configureTableCell:(CKContactsCell*)cell WithContact:(CKUser*)ckUser{
    
    switch (ckUser.userStatus) {
        case kUserStatusContact: {
            [cell.imgBadge setHidden:YES];
            cell.lblDisplayName.textColor = [UIColor whiteColor];
        }
            break;
        case kUserStatusOutgoingContactRequest: {
            
            cell.imgBadge.image = [UIImage imageNamed:@"upload"];
            [cell.imgBadge setHidden:NO];
            cell.imgBadge.layer.cornerRadius = cell.imgBadge.frame.size.height/2;
            cell.imgBadge.layer.masksToBounds = YES;
            cell.lblDisplayName.textColor = [UIColor lightTextColor];
        }
            break;
        case kUserStatusNotContact: {
            cell.imgBadge.image = [UIImage imageNamed:@"plus"];
            [cell.imgBadge setHidden:NO];
            cell.imgBadge.layer.cornerRadius = cell.imgBadge.frame.size.height/2;
            cell.imgBadge.layer.masksToBounds = YES;
            cell.lblDisplayName.textColor = [UIColor whiteColor];
        }
            break;
    }
    
    cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.height/2;
    cell.imgAvatar.layer.masksToBounds = YES;
    cell.lblDisplayName.text = [[[ckUser firstName] stringByAppendingString: @" "] stringByAppendingString: ckUser.lastName];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toNewMemberVC"]){
        CKNewMemberVC *newMemberVC = [segue destinationViewController];
//        newMemberVC.selectedGroup = self.selectedGroup;
    }
    // Pass the selected object to the new view controller.
}

-(IBAction) addNewMember:(id)sender{
    [self performSegueWithIdentifier:@"toNewMemberVC" sender:nil];
}

#pragma mark - Parse

-(void)parseUpdateGroupMembers{
//    [CKNetworkHelper parseRetrieveGroupMembers:self.selectedGroup.groupID WithCompletion:^(NSError *error) {
//        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
//        [CKArchiverHelper saveUserDataToArchive];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.tblGroupMember reloadData];
//        }];
//    }];
//    
//    PFQuery *invitations = [PFQuery queryWithClassName:@"GroupInvitations"];
//    [invitations whereKey:@"groupID" equalTo:self.selectedGroup.groupID];
//    [invitations findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for(PFObject *invitation in objects){
//            
//            PFQuery *user = [PFQuery queryWithClassName:@"_User"];
//            [user whereKey:@"objectId" equalTo:invitation[@"toID"]];
//            [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                
//                CKUser *currentInvite = [self.selectedGroup getPendingMemberWithId:[objects[0] objectId]];
//                if(!currentInvite){
//                    [self.selectedGroup.pendingMembers addObject:objects[0]];
//                }
//                currentInvite = nil;
//            }];
//        }
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.tblGroupMember reloadData];
//        }];
//    }];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
