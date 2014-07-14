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
#import "CKSimpleText.h"
#import "CKNetworkHelper.h"
#import "CKInSimpleMessageCell.h"
#import "CKOutSimpleMessageCell.h"
#import "PaintCodeImages.h"

@interface CKChatVC () <CKGroupRootVCDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) CKAppDelegate *appDelegate;
@property (weak, nonatomic) CKUser *currentUser;
@property (weak, nonatomic) CKGroup *currentUsersGroup;
@property (weak, nonatomic) CKGroupRootVC *parentVC;
@property (strong, nonatomic) NSString *groupMessageName;

@property (weak, nonatomic) IBOutlet UIButton *btnAddMedia;
@property (strong, nonatomic) IBOutlet UIView *vwMessageButtons;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic) BOOL mediaOptionsPresented;
@property (weak, nonatomic) IBOutlet UIView *uivMediaOptions;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnPoll;

- (IBAction)pressedMediaOption:(id)sender;
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
    
    [self configureSubviews];
    
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
    
    self.groupMessageName = [@"messages_" stringByAppendingString: self.parentVC.selectedGroup.groupID];
    self.currentUsersGroup = [self.currentUser getGroupWithId:self.parentVC.selectedGroup.groupID];

}

#pragma mark - Configure Table View

-(void)configureTableView {
    self.tblMessages.delegate = self;
    self.tblMessages.dataSource = self;
}

#pragma mark - Configure Subviews
-(void)configureSubviews{
    
    // Media Options
    self.mediaOptionsPresented = NO;
    self.uivMediaOptions.frame = CGRectOffset(self.uivMediaOptions.frame, 0, 80);
    [self.btnAddMedia setImage:[PaintCodeImages imageOfAddIcon] forState:UIControlStateNormal];
    [self.btnAddMedia setImage:[PaintCodeImages imageOfAddIcon] forState:UIControlStateSelected];
}

#pragma mark - Delegate Group Root

-(void)didMenuOpen:(BOOL)isOpen{
    
}

#pragma mark - Delegate Table View


#pragma mark - Datasource Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentUsersGroup.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CKSimpleText *currentMessage = self.currentUsersGroup.messages[indexPath.row];
    
    if([((PFUser*)currentMessage.creator).objectId isEqualToString:[[PFUser currentUser] objectId]]) {
        CKOutSimpleMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"outgoingMessage"];
        cell.txvMessage.text = currentMessage.textMessage;
        cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
        cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.height*.5;
        cell.imgAvatar.layer.masksToBounds = YES;
        cell.txvMessage.layer.cornerRadius = 5;
        cell.txvMessage.layer.masksToBounds = YES;
//        cell.imgAvatarBadge.layer.cornerRadius = cell.imgAvatarBadge.frame.size.height*.5;
//        cell.imgAvatarBadge.layer.masksToBounds = YES;
        
        return cell;
    } else {
        CKInSimpleMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"incomingMessage"];
        cell.txvMessage.text = currentMessage.textMessage;
        cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
        cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.height*.5;
        cell.imgAvatar.layer.masksToBounds = YES;
        cell.txvMessage.layer.cornerRadius = 5;
        cell.txvMessage.layer.masksToBounds = YES;
//        cell.imgAvatarBadge.layer.cornerRadius = cell.imgAvatarBadge.frame.size.height*.5;
//        cell.imgAvatarBadge.layer.masksToBounds = YES;
        return cell;
    }
    
//    if(self.currentUsersGroup.messages.count-1 == indexPath.row){
//        [self scrollTableAnimated:YES];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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

- (IBAction)pressedMediaOption:(id)sender {
    
    UIButton *btnMediaOption = (UIButton *)sender;
    
    switch (btnMediaOption.tag) {
        case 0: { // Event
            [self pressedAdd:nil];
            [self.parentVC openRightMenu];
            [self.parentVC makeAllEventsVCVisible];
        }
            break;
        case 1: // Camera
            
            break;
        case 2: // Poll
            
            break;
    }
    
}

- (IBAction)pressedAdd:(id)sender {

    [self.btnAddMedia setSelected: !self.btnAddMedia.isSelected];
    [self presentMediaOptions:self.btnAddMedia.isSelected];
    
}

- (IBAction)pressedSend:(id)sender {
    
    // Parse, post message to group messages
    PFObject *newMessage = [PFObject objectWithClassName:self.groupMessageName];
    newMessage[@"from_user"] = [PFUser currentUser];
    newMessage[@"to_user"] = @"*"; // Indicates all users can read
    newMessage[@"messageString"] = self.txtMessage.text;
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            self.txtMessage.text = @"";
            [CKNetworkHelper parseRetrieveMessageForGroupId:self.parentVC.selectedGroup.groupID withCompletion:^(NSError *error) {
                [self.tblMessages reloadData];
                [self scrollTableAnimated:YES];
                NSLog(@"%@", error.localizedDescription);
            }];
        }
    }];
    
}

- (IBAction)pressedTextMessage:(id)sender {
    
}

#pragma mark - Animate SubViews

-(void)presentMediaOptions:(BOOL)show{
    
    float dy = show ? -40 : 40;
    
    [UIView animateWithDuration:.3 animations:^{
        self.tblMessages.frame = CGRectMake(self.tblMessages.frame.origin.x,
                                            self.tblMessages.frame.origin.y,
                                            self.tblMessages.frame.size.width,
                                            self.tblMessages.frame.size.height+dy);
        self.uivMediaOptions.frame = CGRectOffset(self.vwMessageButtons.frame, 0, dy);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)presentEventCreator:(BOOL)show{
  
}

#pragma mark - Animate Keyboard/ Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    [UIView animateWithDuration:.3 animations:^{
        self.tblMessages.frame = CGRectMake(self.tblMessages.frame.origin.x,
                                            self.tblMessages.frame.origin.y,
                                            self.tblMessages.frame.size.width,
                                            self.tblMessages.frame.size.height-220);
    } completion:^(BOOL finished) {
        
    }];

    [self scrollTableAnimated:YES];
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

#pragma mark - Scroll Messages

-(void)scrollTableAnimated:(BOOL)animated{
    if(self.parentVC.selectedGroup.messages.count>0){
        [self.tblMessages scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: self.parentVC.selectedGroup.messages.count-1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    [self.view endEditing:YES];
    
//    [UIView animateWithDuration: .25
//                          delay: 0.0f
//                        options: 7
//                     animations:^ {
//                         self.vwMessageButtons.frame = CGRectMake(self.vwMessageButtons.frame.origin.x,
//                                                                  self.view.frame.size.height-self.vwMessageButtons.frame.size.height-50,
//                                                                  self.vwMessageButtons.frame.size.width,
//                                                                  self.vwMessageButtons.frame.size.height);
//                     } completion:NULL];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
