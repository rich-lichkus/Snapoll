//
//  CKContactsVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKContactsVC.h"
#import "CKContactsCell.h"

@interface CKContactsVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CKUser *currentUser;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segSearchLocation;
@property (weak, nonatomic) IBOutlet UISearchBar *srbSearch;

@property (strong, nonatomic) NSMutableArray *contactSearchResults;

@end

@implementation CKContactsVC

#pragma mark - View

-(void) viewWillAppear:(BOOL)animated{
    
    [self parseUpdateContacts];
    
    [self.tblContacts reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTables];
    
    [self configureSearchBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Configure and Setup Functions

-(void)configureTables {
    self.tblContacts.delegate = self;
    self.tblContacts.dataSource = self;
}

-(void)configureSearchBar{
    self.srbSearch.delegate =self;
    for (UIView *view in self.srbSearch.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *txtSearch = (UITextField *)view;
            txtSearch.delegate = self;
            break;
        }
    }
}

#pragma mark - Search Bar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.srbSearch.showsCancelButton = YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.contactSearchResults = [NSMutableArray new];
    if (self.segSearchLocation.selectedSegmentIndex == 0) {

        NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"userName", self.srbSearch.text];
        [self.contactSearchResults addObjectsFromArray:[self.currentUser.contacts filteredArrayUsingPredicate:userNamePredicate]];
        [self.contactSearchResults addObjectsFromArray:[self.currentUser.incomingContactRequests filteredArrayUsingPredicate:userNamePredicate]];
        [self.contactSearchResults addObjectsFromArray:[self.currentUser.outgoingContactRequests filteredArrayUsingPredicate:userNamePredicate]];
        [self.tblContacts reloadData];
        [self.srbSearch resignFirstResponder];
    } else {
        PFQuery *searchQuery = [PFQuery queryWithClassName:@"_User"];
        [searchQuery whereKey:@"username" containsString:self.srbSearch.text];
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (PFUser *pfUser in objects){
                CKUser *newUser = [[CKUser alloc] initPrimitivesWithPFUser:pfUser];
                newUser.userStatus = [self.currentUser getContactStatusForUserId:newUser.userID];
                [self.contactSearchResults addObject: newUser];
            }
            [self.tblContacts reloadData];
            [self.srbSearch resignFirstResponder];
        }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.contactSearchResults = nil;
    [self.srbSearch resignFirstResponder];
    [self.tblContacts reloadData];
    self.srbSearch.showsCancelButton = NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.contactSearchResults = nil;
    [self.srbSearch resignFirstResponder];
    [self.tblContacts reloadData];
    return YES;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger numSections = 0;
    
    if (self.contactSearchResults){
        numSections = 1;
    } else {
        numSections = 3; // Incoming, Contacts, Outgoing
    }
    
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    if (self.contactSearchResults){
        numRows = self.contactSearchResults.count;
    } else {
        switch (section) {
            case 0:
                numRows = self.currentUser.incomingContactRequests.count;
                break;
            case 1:
                numRows = self.currentUser.contacts.count;
                break;
            case 2:
                numRows = self.currentUser.outgoingContactRequests.count;
                break;
        }
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
    
    CKUser *currentContact;
    
    if (self.contactSearchResults) {
        currentContact  = self.contactSearchResults[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0: {
                currentContact  = self.currentUser.incomingContactRequests[indexPath.row];
            }
                break;
            case 1: {
                currentContact  = self.currentUser.contacts[indexPath.row];
            }
                break;
            case 2: {
                currentContact = self.currentUser.outgoingContactRequests[indexPath.row];
            }
                break;
        }
    }
    
    [self configureTableCell:cell WithContact:currentContact];
    
    return cell;
}

-(void)configureTableCell:(CKContactsCell*)cell WithContact:(CKUser*)ckUser{
    
    switch (ckUser.userStatus) {
        case kUserStatusIncomingContactRequest: {
            
            [cell.imgBadge setHidden:NO];
            cell.imgBadge.image = [UIImage imageNamed:@"download"];
            cell.imgBadge.layer.cornerRadius = cell.imgBadge.frame.size.height/2;
            cell.imgBadge.layer.masksToBounds = YES;
            cell.lblDisplayName.textColor = [UIColor lightTextColor];
        }
            break;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKUser *selectedContact;
    
    if(self.contactSearchResults){
        selectedContact = self.contactSearchResults[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0:
                selectedContact = self.currentUser.incomingContactRequests[indexPath.row];
                break;
            case 1:
                selectedContact = self.currentUser.contacts[indexPath.row];
                break;
            case 2:
                selectedContact = self.currentUser.outgoingContactRequests[indexPath.row];
                break;
        }
    }
    
    [self.delegate didSelectContact:selectedContact];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Network

-(void)parseUpdateContacts{
    
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    [CKNetworkHelper parseRetrieveContacts:self.currentUser.userID WithCompletion:^(NSError *error) {
        self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tblContacts reloadData];
        }];
    }];
    
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
