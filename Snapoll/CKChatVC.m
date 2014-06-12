//
//  CKChatVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 4/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKChatVC.h"

#import "CKUser.h"
#import "CKAppDelegate.h"

@interface CKChatVC ()

@property (strong, nonatomic) CKAppDelegate *appDelegate;
@property (strong, nonatomic) CKUser *currentUser;

@property (strong, nonatomic) IBOutlet UIView *vwMessageButtons;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.currentUser = ((CKAppDelegate*)[[UIApplication sharedApplication]delegate]).currentUser;
    
    self.txtMessage.delegate = self;
    self.colMessages.delegate = self;
    self.colMessages.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"message" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
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

#pragma mark - Buttons

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





@end
