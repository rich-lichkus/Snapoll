//
//  CKPollVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 7/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKPollVC.h"
#import "PaintCodeImages.h"
#import "CKDetailEventCell.h"
#import "CKAllEventsVC.h"

@interface CKPollVC()<UITableViewDataSource, UITableViewDelegate, CKAllEventsVCDelegate>

@property (nonatomic) BOOL editMode;
@property (weak, nonatomic) CKEvent *selectedPoll;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tblPolls;

@property (weak, nonatomic) IBOutlet UIButton *btnWhat;
@property (weak, nonatomic) IBOutlet UIButton *btnWhen;
@property (weak, nonatomic) IBOutlet UIButton *btnWhere;
@property (weak, nonatomic) IBOutlet UIButton *btnWho;

- (IBAction)pressedBack:(id)sender;
- (IBAction)pressedEdit:(id)sender;

@end

@implementation CKPollVC

#pragma mark - View Load

-(void)viewDidLoad{
    NSLog(@"did load Poll VC");
    
    [super viewDidLoad];
    
    [self configureTableView];
    
    [self configureUIElements];
    
    [self configureStates];
}

#pragma mark - Configure

-(void)configureStates{
    self.editMode = NO;
}

-(void)configureTableView{
    self.tblPolls.delegate = self;
    self.tblPolls.dataSource = self;
}

-(void)configureUIElements{
    
    // Back Button
    [self.btnBack setImage:[PaintCodeImages imageOfCircleLeftBackArrow] forState:UIControlStateNormal];
    [self.btnEdit setImage:[PaintCodeImages imageOfEdit] forState:UIControlStateNormal];
    
    // Location Button
    [self.btnWhat setImage:[PaintCodeImages imageOfQuestionMark] forState:UIControlStateNormal];
    [self.btnWhen setImage:[PaintCodeImages imageOfClock] forState:UIControlStateNormal];
    [self.btnWhere setImage:[PaintCodeImages imageOfLocationPin] forState:UIControlStateNormal];
    [self.btnWho setImage:[PaintCodeImages imageOfPerson] forState:UIControlStateNormal];
    
}

#pragma mark - whatever

- (void)loadSelectedPoll:(CKEvent *)selectedPoll
{
    self.selectedPoll = selectedPoll;
    [self.tblPolls reloadData];
    NSLog(@"%@", selectedPoll.description);
}

#pragma mark - Table View Delegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numRows =0;
    
    switch (section) {
        case 0: { // What
            if(self.selectedPoll.boolFinalWhat){
                numRows = 0;
            } else {
                numRows = self.selectedPoll.optionsWhat.count;
            }
        }
            break;
        case 1: { // Where
            if(self.selectedPoll.boolFinalWhere){
                numRows = 0;
            } else {
                numRows = self.selectedPoll.optionsWhere.count;
            }
        }
            break;
        case 2: { // When
            if(self.selectedPoll.boolFinalWhen){
                numRows = 0;
            } else {
                numRows = self.selectedPoll.optionsWhen.count;
            }
        }
            break;
        case 3:{ // Who
            if(self.selectedPoll.boolFinalAttendees){
                numRows = self.selectedPoll.finalAttendees.count;
            } else {
                numRows = self.selectedPoll.optionsWho.count;
            }
        }
            break;
    }
    return numRows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    NSArray *avatar = @[[PaintCodeImages imageOfQuestionMark],
                        [PaintCodeImages imageOfLocationPin],
                        [PaintCodeImages imageOfClock],
                        [PaintCodeImages imageOfPerson]];
    
    CKDetailEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailEventsCell" forIndexPath:indexPath];
    
    [cell.btnAddOption setImage:[PaintCodeImages imageOfAddIcon] forState:UIControlStateNormal];
    [cell.btnSelectionStyle setImage:[PaintCodeImages imageOfSelectedRadio] forState:UIControlStateNormal];
    
    switch (indexPath.section) {
        case 0: { // Where
            if(self.selectedPoll.boolFinalWhat) {
                cell.txtField.text = self.selectedPoll.finalWhat;
            } else {
                cell.txtField.text = self.selectedPoll.optionsWhat[indexPath.row];
            }
        }
            break;
        case 1: { // Where
            if(self.selectedPoll.boolFinalWhere) {
                cell.txtField.text = self.selectedPoll.finalWhen.description;
            } else {
                cell.txtField.text = self.selectedPoll.optionsWhen[indexPath.row];
            }
        }
            break;
        case 2: { // When
            if(self.selectedPoll.boolFinalWhen) {
                cell.txtField.text = self.selectedPoll.finalWhereString;
            } else {
                cell.txtField.text = self.selectedPoll.optionsWhere[indexPath.row];
            }
        }
            break;
        case 3: { // Who
            if(self.selectedPoll.boolFinalAttendees) {
                cell.txtField.text = self.selectedPoll.finalAttendees[indexPath.row];
            } else {
                cell.txtField.text = self.selectedPoll.optionsWho[indexPath.row];
            }
        }
            break;
    }

    cell.txtField.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.000];
    
    if(self.editMode){
        [UIView animateWithDuration:.2
                         animations:^{
                             cell.txtField.frame = CGRectMake(cell.txtField.frame.origin.x+20,
                                                              cell.txtField.frame.origin.y,
                                                              cell.txtField.frame.size.width-20,
                                                              cell.txtField.frame.size.height
                                                              );
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
//    cell.imgAvatar.image = avatar[indexPath.section];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *sectionImages;
    sectionImages = @[[PaintCodeImages imageOfQuestionMark],
                      [PaintCodeImages imageOfClock],
                      [PaintCodeImages imageOfLocationPin],
                      [PaintCodeImages imageOfPerson]];
    
    NSArray *sectionTitles = @[self.selectedPoll.finalWhat, self.selectedPoll.finalWhen.description, self.selectedPoll.finalWhereString, @"Attending"];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.250];
    
    UIImageView *sectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    sectionImage.image = sectionImages[section];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, tableView.frame.size.width-70,30 )];
    sectionTitle.text = sectionTitles[section];
    
    UIButton *btnLockImage = [[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-30,0,30,30)];
    btnLockImage.showsTouchWhenHighlighted = YES;
    [btnLockImage addTarget:self action:@selector(pressedLock:) forControlEvents:UIControlEventTouchUpInside];
    [btnLockImage setImage:[PaintCodeImages imageOfClosedLock] forState:UIControlStateHighlighted];
    [btnLockImage setImage:[PaintCodeImages imageOfOpenLock] forState:UIControlStateNormal];
    
    [view addSubview:sectionImage];
    [view addSubview:sectionTitle];
    [view addSubview:btnLockImage];
    
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.000];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - Actions

-(void)pressedLock:(UIButton*)sender{
    [sender setHighlighted:YES];
}

- (IBAction)pressedBack:(id)sender {
    [self.delegate didSelectPollExit];
}

- (IBAction)pressedEdit:(id)sender {
    self.editMode = YES;
    [self.tblPolls reloadData];
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}


@end


