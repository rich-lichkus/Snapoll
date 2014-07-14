//
//  CKLoginVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLoginVC.h"
#import "CKAppDelegate.h"
#import "PaintCodeImages.h"
#import "CKConstants.h"

@interface CKLoginVC ()

@property (strong, nonatomic) CKAppDelegate *appDelegate;
@property (nonatomic) kLoginOption loginOption;
@property (nonatomic) CGFloat lockRotation;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIView *uivAlertView;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorLabel;

- (IBAction)pressedLogin:(id)sender;
- (IBAction)pressedLoginOption:(id)sender;
- (IBAction)pressedSignup:(id)sender;

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

    [self configureUIElements];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];

}

-(void) configureUIElements{
    //self.imgBackground.image = [PaintCodeImages imageOfLoginBackground];
    self.txtPassword.layer.cornerRadius =5;
    self.txtPassword.layer.masksToBounds =5;
    self.txtPassword.secureTextEntry = YES;
    self.txtUsername.layer.cornerRadius =5;
    self.txtUsername.layer.masksToBounds =5;
    
    // Login Buttons
    [self.btnFacebook setImage:[PaintCodeImages imageOfFacebookLoginWithSelected:NO] forState:UIControlStateNormal];
    [self.btnFacebook setImage:[PaintCodeImages imageOfFacebookLoginWithSelected:YES] forState:UIControlStateSelected];
    [self.btnFacebook setSelected:YES];
    self.loginOption = kFacebookLogin;
    [self.btnTwitter setImage:[PaintCodeImages imageOfTwitterLoginWithSelected:NO] forState:UIControlStateNormal];
    [self.btnTwitter setImage:[PaintCodeImages imageOfTwitterLoginWithSelected:YES] forState:UIControlStateSelected];
    [self.btnEmail setImage:[PaintCodeImages imageOfEmailLoginWithSelected:NO] forState:UIControlStateNormal];
    [self.btnEmail setImage:[PaintCodeImages imageOfEmailLoginWithSelected:YES] forState:UIControlStateSelected];
    [self.btnLogin setImage:[PaintCodeImages imageOfLoginLockWithLockRotation: self.lockRotation] forState:UIControlStateNormal];
    
    // UIView
    self.uivAlertView.hidden = YES;
    self.lblErrorLabel.hidden = YES;
}

-(void)presentErrorView:(BOOL)show {
    
    float dy = show ? -35 : 35;
    self.uivAlertView.hidden = show;
    
    [UIView animateWithDuration:.3 animations:^{
        self.uivAlertView.frame = CGRectOffset(self.uivAlertView.frame, 0, dy);
    } completion:^(BOOL finished) {
        
    }];
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

#pragma mark - Actions


- (IBAction)pressedLogin:(id)sender {
    
    if((self.txtPassword.text.length > 0) && (self.txtUsername.text.length > 0)) {

        // Parse Call
        switch (self.loginOption) {
            case kFacebookLogin: {
//                [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
//                    
//                }];
                
            }
                break;
            
            case kTwitterLogin: {
                
                
            }
                break;
            
            case kEmailLogin: {
                [CKNetworkHelper parseLogInWithUsername:self.txtUsername.text andPassword:self.txtPassword.text completionBlock:^(PFUser *user, NSError *error) {
                        [self user:user AndError:error];
                    }];
            }
                break;
        }
    }
    
    [UIView animateWithDuration:3 animations:^{
        self.lockRotation = 50;
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:3 animations:^{
//            self.lockRotation = -50;
//        } completion:^(BOOL finished) {
//            
//        }];
    }];
    

}

-(void) user:(PFUser*)user AndError:(NSError*)error {
    if(user){
        
        // Load Archive copy
        [CKArchiverHelper initialLoadUserDataFromArchive:self.txtUsername.text];
        
        // Convert PFUser to CKUser and update current user instance in app del
        [((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser updateCurrentUserWithPFUser:user];
        
        // Archive current user
        //[CKArchiverHelper saveUserDataToArchive];
        
        // Segue to app menu, which loads groups vc by default
        [self performSegueWithIdentifier:@"toHotBoxRootVC" sender:nil];
        
    } else {
        // Error label displayed if sign is not authenticated
        [self presentErrorView:YES];
        self.lblErrorLabel.text = @"Login Failed.";
    }
}

- (IBAction)pressedLoginOption:(id)sender {
    
    UIButton *loginOption = (UIButton*)sender;
    
    [self.btnFacebook setSelected:NO];
    [self.btnTwitter setSelected:NO];
    [self.btnEmail setSelected:NO];
    
    switch (loginOption.tag) {
        case 0:
            [self.btnFacebook setSelected:YES];
            self.txtUsername.placeholder = @"Facebook";
            self.loginOption = kFacebookLogin;
            break;
        case 1:
            [self.btnTwitter setSelected:YES];
            self.txtUsername.placeholder = @"Twitter";
            self.loginOption = kTwitterLogin;
            break;
        case 2:
            [self.btnEmail setSelected:YES];
            self.txtUsername.placeholder = @"Email";
            self.loginOption = kEmailLogin;
            break;
    }
}

- (IBAction)pressedSignup:(id)sender {
    
    [self presentErrorView:YES];
    
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
