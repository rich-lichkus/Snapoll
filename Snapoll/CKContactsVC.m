//
//  CKContactsVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKContactsVC.h"
#import "CKContactsCell.h"

@interface CKContactsVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CKUser *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentUser.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
    
    CKUser *currentContact = self.currentUser.contacts[indexPath.row];
    
    cell.imgAvatar.layer.shouldRasterize = YES;
    cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.height/2;
    cell.imgAvatar.layer.masksToBounds = YES;
    cell.lblDisplayName.text = [[[currentContact firstName] stringByAppendingString: @" " ] stringByAppendingString: currentContact.lastName];
    cell.imgBadge.layer.cornerRadius = cell.imgBadge.frame.size.height/2;
    cell.imgBadge.layer.masksToBounds = YES;
    
    
    
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
