//
//  CKAllEventsVC.m
//  Snapoll
//
//  Created by Richard Lichkus on 6/10/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKAllEventsVC.h"

@interface CKAllEventsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblEvents;

@end

@implementation CKAllEventsVC

#pragma mark - Views

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTables];
}

#pragma mark - Table 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allEventsCell"];
    
    cell.textLabel.text = @"Party 111111";
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

#pragma mark - Configure Tables

-(void)configureTables {
    self.tblEvents.delegate = self;
    self.tblEvents.dataSource  = self;
}

#pragma mark - Memory

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
