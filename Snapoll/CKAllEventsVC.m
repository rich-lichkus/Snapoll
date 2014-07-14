//
//  CKAllEventsVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKAllEventsVC.h"
#import "CKEventsCell.h"
#import "PaintCodeImages.h"

@interface CKAllEventsVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CKEvent *tempEvent;

@property (weak, nonatomic) IBOutlet UITableView *tblEvents;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPollType;

- (IBAction)pressedSegmentedControl:(id)sender;

@end

@implementation CKAllEventsVC

#pragma mark - Views

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTables];
    
    [self configureSegmentedControl];
}


#pragma mark - Configure

-(void)configureTables {
    self.tblEvents.delegate = self;
    self.tblEvents.dataSource  = self;
}

-(void)configureSegmentedControl{
    [self.segPollType setImage:[PaintCodeImages imageOfEventIcon] forSegmentAtIndex:0];
    [self.segPollType setImage:[PaintCodeImages imageOfPollIcon] forSegmentAtIndex:1];
}

#pragma mark - Table 

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *sectionTitles;

    sectionTitles = @[@"Fake Group"];
    
    NSString *title = [sectionTitles objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setText:title];
    [view addSubview:label];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allEventsCell"];
    
    switch (self.segPollType.selectedSegmentIndex) {
        case 0:
            cell.lblMainTitle.text = @"Pool Party";
            break;
        case 1:
            cell.lblMainTitle.text = @"Favorite Icecream";
            break;
    }
    
    cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.width/2;
    cell.imgAvatar.layer.masksToBounds = YES;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tempEvent = [[CKEvent alloc]init];
    self.tempEvent.creator = [[CKUser alloc] initPrimitivesWithPFUser:[PFUser currentUser]];
    self.tempEvent.finalWhat = @"World Cup Futbol Party";
    self.tempEvent.finalWhen = [NSDate date];
    self.tempEvent.finalWhereString = @"Yard house";
    self.tempEvent.boolFinalAttendees = NO;
    self.tempEvent.boolFinalWhat = YES;
    self.tempEvent.boolFinalWhen = YES;
    self.tempEvent.boolFinalWhere = YES;
    self.tempEvent.optionsWho = [NSMutableArray arrayWithArray: @[@"Richard Lichkus", @"Bryan Patricca", @"Tyler Smith"]];
    [self.delegate didSelectPoll:self.tempEvent];
    
}

#pragma mark - Actions

- (IBAction)pressedSegmentedControl:(id)sender {
    [self.tblEvents reloadData];
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
