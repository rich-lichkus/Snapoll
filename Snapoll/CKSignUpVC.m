//
//  CKSignUpVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 5/1/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKSignUpVC.h"


@interface CKSignUpVC ()
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPasswordConfirm;

- (IBAction)pressedCreateAccount:(id)sender;
@end

@implementation CKSignUpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)pressedCreateAccount:(id)sender {
    if([self.txtPassword.text isEqualToString:self.txtPasswordConfirm.text]
       && self.txtUsername.text.length>0 )
    {
        // Create new account
        
        PFUser *user = [PFUser user];
        user.username = self.txtUsername.text;
        user.password = self.txtPassword.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [self performSegueWithIdentifier:@"toGroupMenuSignUp" sender:nil];
                NSLog(@"Success!");
            } else {
                NSLog(@"%@",[error userInfo][@"error"]);
            }
        }];
    }
}
         
         
@end
