//
//  CKNewGroupVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKNewGroupVC.h"
#import "CKAppDelegate.h"
#import "CKNetworkHelper.h"
#import "CKGroup.h"

@interface CKNewGroupVC ()

@property (strong, nonatomic) CKUser *currentUser;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property (strong, nonatomic) IBOutlet UITextField *txtGroupName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGroupType;

- (IBAction)segChanged:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)addPressed:(id)sender;

@end

@implementation CKNewGroupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    self.segGroupType.selectedSegmentIndex = 0;
}

#pragma mark - Buttons

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)addPressed:(id)sender {
    if(self.txtGroupName.text.length > 0){
        
        switch ([self.segGroupType selectedSegmentIndex]) {
            case 0: // Create New Group
            {
                [CKNetworkHelper parseAddNewGroup:self.txtGroupName.text withCompletion:^(NSError *addGroupError, NSError *addGroupToUserError) {
                    if (addGroupError){
                        NSLog(@"NewGroupVC: %@",[addGroupError userInfo][@"error"]);
                    } else if (addGroupToUserError){
                        NSLog(@"NewGroupVC: %@",[addGroupToUserError userInfo][@"error"]);
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{}];
                    }
                }];
            }
                break;
            case 1: // Join existing Group
            {
                PFQuery *getGroup = [PFQuery queryWithClassName:@"Group"];
                [getGroup whereKey:@"objectId" equalTo:self.txtGroupName.text];
                [getGroup findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if(objects.count == 0){ // Group ID not Valid
                        NSLog(@"NewGroupVC: Group ID not Found.");
                    } else if (objects.count == 1){
                        
                        // Add user to group
                        PFObject *groupObject = objects[0];
                        [groupObject incrementKey:@"memberCount"];
                        
                        // Add user to the new group
                        PFRelation *newMemberRelation = [groupObject relationForKey:@"members"];
                        [newMemberRelation addObject:[PFUser currentUser]];
                        [groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                // Add group to user
                                PFUser *user = [PFUser currentUser];
                                PFRelation *relation = [user relationforKey:@"groups"];
                                [relation addObject:groupObject];
                                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if(succeeded){
                                        [self dismissViewControllerAnimated:YES completion:^{}];
                                    }else{
                                        NSLog(@"%@",[error userInfo][@"error"]);
                                    }
                                }];
                            } else {
                                NSLog(@"%@",[error userInfo][@"error"]);
                            }
                        }];
                    } else {
                        NSLog(@"%@",[error userInfo][@"error"]);
                    }
                }];
                
            }
                break;
        }
    }
}

#pragma mark - IBActions

- (IBAction)segChanged:(id)sender {
    if(self.segGroupType.selectedSegmentIndex == 0){
        self.txtGroupName.placeholder = @"New Group Name";
    } else {
        self.txtGroupName.placeholder = @"Group ID";
    }
    
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
