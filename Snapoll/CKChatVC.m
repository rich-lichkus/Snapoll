//
//  CKChatVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKChatVC.h"
#import "CKHotBoxRootVC.h"
#import "CKUser.h"
#import "CKAppDelegate.h"

@interface CKChatVC () <CKGroupRootVCDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) CKAppDelegate *appDelegate;
@property (weak, nonatomic) CKUser *currentUser;
@property (weak, nonatomic) CKGroupRootVC *parentVC;

@property (weak, nonatomic) IBOutlet UITableView *tblMessages;
@property (strong, nonatomic) IBOutlet UIView *vwMessageButtons;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)pressedAdd:(id)sender;
- (IBAction)pressedSend:(id)sender;
- (IBAction)pressedTextMessage:(id)sender;

@end

@implementation CKChatVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Views

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTableView];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    self.txtMessage.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - Configure group root

-(void) configureParentDelegate:(CKGroupRootVC*)parentVC{
    self.parentVC = parentVC;
    self.parentVC.delegate = self;
    self.navBar.topItem.title = self.parentVC.selectedGroup.groupName;
}

#pragma mark - Configure Table View

-(void)configureTableView {
    self.tblMessages.delegate = self;
    self.tblMessages.dataSource = self;
}

#pragma mark - Delegate Group Root

-(void)didMenuOpen:(BOOL)isOpen{
    
}

#pragma mark - Delegate Table View


#pragma mark - Datasource Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    cell.textLabel.text = @"Hello";
    
    return cell;
}

#pragma mark - Navigation

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Actions

- (IBAction)pressedAdd:(id)sender {
 
}

- (IBAction)pressedSend:(id)sender {
    
}

- (IBAction)pressedTextMessage:(id)sender {
    
}

#pragma mark - Animate Keyboard/ Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)keyboardWillShow:(NSNotification*)notification
{
    [UIView animateWithDuration: .25f   //[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue]+.25
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveLinear //[notification.userInfo [UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^ {
                         self.vwMessageButtons.frame = CGRectMake(self.vwMessageButtons.frame.origin.x,
                                                                  self.view.frame.size.height-216-self.vwMessageButtons.frame.size.height,
                                                                  self.vwMessageButtons.frame.size.width,
                                                                  self.vwMessageButtons.frame.size.height);
                     } completion:NULL];
}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration: .25
                          delay: 0.0f
                        options: 7
                     animations:^ {
                         self.vwMessageButtons.frame = CGRectMake(self.vwMessageButtons.frame.origin.x,
                                                                  self.view.frame.size.height-self.vwMessageButtons.frame.size.height-50,
                                                                  self.vwMessageButtons.frame.size.width,
                                                                  self.vwMessageButtons.frame.size.height);
                     } completion:NULL];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
