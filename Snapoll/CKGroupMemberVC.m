//
//  CKGroupMemberVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupMemberVC.h"

@interface CKGroupMemberVC() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CKUser *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tblGroupMember;

@end

@implementation CKGroupMemberVC

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // [self parseUpdateGroupMembers];
    
    //[self.tableView reloadData];
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
    if(self.selectedGroup.pendingMembers >0){
        return 2;
    } else {
        return 1;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    switch (section) {
        case 0:
            title = @"Members";
            break;
        case 1:
            title = @"Invites";
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger *numRows =0;
    switch (section) {
        case 0:
        {
            numRows = self.selectedGroup.members.count;
        }
            break;
            
        case 1:
        {
            numRows = self.selectedGroup.pendingMembers.count;
        }
            break;
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell" forIndexPath:indexPath];
    switch (indexPath.section) {
            
        case 0:
        {
            CKUser *currentMember = self.selectedGroup.members[indexPath.row];
            cell.imageView.layer.shouldRasterize = YES;
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
            cell.imageView.layer.masksToBounds = YES;
            cell.textLabel.text = [[[currentMember firstName] stringByAppendingString: @" "] stringByAppendingString: currentMember.lastName];
            cell.detailTextLabel.text = [@"$" stringByAppendingString: [currentMember userName]];
        }
            break;
        case 1:
        {
            PFUser *currentMember = self.selectedGroup.pendingMembers[indexPath.row];
            cell.imageView.layer.shouldRasterize = YES;
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
            cell.imageView.layer.masksToBounds = YES;
            cell.textLabel.text = [[currentMember[@"firstName"] stringByAppendingString: @" "] stringByAppendingString: currentMember[@"lastName"]];
            cell.detailTextLabel.text = [@"$" stringByAppendingString:currentMember[@"username"]];
        }
            break;
    }
    return cell;
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
        newMemberVC.selectedGroup = self.selectedGroup;
    }
    // Pass the selected object to the new view controller.
}

-(IBAction) addNewMember:(id)sender{
    [self performSegueWithIdentifier:@"toNewMemberVC" sender:nil];
}

#pragma mark - Parse

-(void)parseUpdateGroupMembers{
    [CKNetworkHelper parseRetrieveGroupMembers:self.selectedGroup.groupID WithCompletion:^(NSError *error) {
        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
        [CKArchiverHelper saveUserDataToArchive];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tblGroupMember reloadData];
        }];
    }];
    
    PFQuery *invitations = [PFQuery queryWithClassName:@"GroupInvitations"];
    [invitations whereKey:@"groupID" equalTo:self.selectedGroup.groupID];
    [invitations findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject *invitation in objects){
            
            PFQuery *user = [PFQuery queryWithClassName:@"_User"];
            [user whereKey:@"objectId" equalTo:invitation[@"toID"]];
            [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                CKUser *currentInvite = [self.selectedGroup getPendingMemberWithId:[objects[0] objectId]];
                if(!currentInvite){
                    [self.selectedGroup.pendingMembers addObject:objects[0]];
                }
                currentInvite = nil;
            }];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tblGroupMember reloadData];
        }];
    }];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
