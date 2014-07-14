//
//  CKGroupEventsVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKGroupEventsVC.h"
#import "CKEventsCell.h"
#import "PaintCodeImages.h"

@interface CKGroupEventsVC() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segPollType;

@end

@implementation CKGroupEventsVC

#pragma mark - Views

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureTableView];
    
    [self configureSegmentedControl];
}

#pragma mark - Configure

-(void)configureTableView{
    self.tblGroupEvents.delegate = self;
    self.tblGroupEvents.dataSource = self;
}

-(void)configureSegmentedControl{
    [self.segPollType setImage:[PaintCodeImages imageOfEventIcon] forSegmentAtIndex:0];
    [self.segPollType setImage:[PaintCodeImages imageOfPollIcon] forSegmentAtIndex:1];
}

#pragma mark - Table View Datasource and Delegate

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CKEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupEventsCell"forIndexPath:indexPath];
    
    switch (self.segPollType.selectedSegmentIndex) {
        case 0:
            cell.lblMainTitle.text = @"Group Event";
            break;
        case 1:
            cell.lblMainTitle.text = @"Favorite Car";
            break;
    }
    
    cell.imgAvatar.image = [UIImage imageNamed:@"placeholder"];
    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.width/2;
    cell.imgAvatar.layer.masksToBounds = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CKEvent *event = [[CKEvent alloc]init];
    event.creator = [[CKUser alloc] initPrimitivesWithPFUser:[PFUser currentUser]];
    event.finalWhat = @"World Cup Futbol Party";
    event.finalWhen = [NSDate date];
    event.finalWhereString = @"Yard house";
    [self.delegate didSelectPoll:event];
    NSLog(@"selected row");
}

//#pragma mark - Delegate
//
//-(void)loadSelectedPoll:(CKEvent *)selectedPoll{
//    
//}

#pragma mark - Actions

- (IBAction)pressedSegmentedControl:(id)sender {
    [self.tblGroupEvents reloadData];
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




@end
