//
//  CKLoginVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLoginVC.h"
#import "CKAppDelegate.h"


@interface CKLoginVC ()

@property (strong, nonatomic) CKAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UILabel *lblErrorMessage;

- (IBAction)pressedLogin:(id)sender;

@end

@implementation CKLoginVC

#pragma mark - Instantiation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Load/ Appear

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lblErrorMessage.hidden = YES;
    self.appDelegate = [[UIApplication sharedApplication] delegate];

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

#pragma mark - Login

- (IBAction)pressedLogin:(id)sender {
    
    if((self.txtPassword.text.length > 0) && (self.txtUsername.text.length > 0)) {
        
        // Parse Call
        [CKNetworkHelper parseLogInWithUsername:self.txtUsername.text
                                    andPassword:self.txtPassword.text
                                completionBlock:^(PFUser *user, NSError *error) {
            if(user){
                // Load Archive copy
                [CKArchiverHelper initialLoadUserDataFromArchive:self.txtUsername.text];
                
                // Convert PFUser to CKUser and update current user instance in app del
                [((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser updateCurrentUserWithPFUser:user];
                
                // Archive current user
                [CKArchiverHelper saveUserDataToArchive];
               
                // Segue to app menu, which loads groups vc by default
                [self performSegueWithIdentifier:@"toHotBoxRootVC" sender:nil];

            } else {
                // Error label displayed if sign is not authenticated
                self.lblErrorMessage.hidden = NO;
            }
        }];
    }
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
