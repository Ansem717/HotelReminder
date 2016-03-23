//
//  BookRoomsViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/22/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "BookRoomsViewController.h"
#import "BookGuestViewController.h"
#import "AppDelegate.h"
#import "Room.h"
#import "Hotel.h"

@interface BookRoomsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * datasource;
@property (strong, nonatomic) UITableView * roomsTableView;

@end

@implementation BookRoomsViewController

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray new];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSFetchRequest *q = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        NSError *error;
        NSArray *result = [context executeFetchRequest:q error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            for (Hotel *hotel in result) {
                [_datasource addObject:hotel];
            }
        }
    }
    return _datasource;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Reserve Room"];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTableView {
//    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame)+20;
    
    self.roomsTableView = [[UITableView alloc]init];
    self.roomsTableView.delegate = self;
    self.roomsTableView.dataSource = self;
    self.roomsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.roomsTableView];
    [self.roomsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.roomsTableView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.roomsTableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.roomsTableView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.roomsTableView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0];
    
    leading.active = YES;
    top.active = YES;
    trailing.active = YES;
    bottom.active = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.datasource objectAtIndex:section] rooms] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray * roomsInSection = [[[self.datasource objectAtIndex:indexPath.section] rooms] allObjects];
    Room *room = [roomsInSection objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Room %@ - %@ beds for $%@.99 per night", room.roomNum, room.numOfBeds, room.rate];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Hotel * sectionHotel = [self.datasource objectAtIndex:section];
    return sectionHotel.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookGuestViewController * bookGuestVC = [[BookGuestViewController alloc]init];
    bookGuestVC.startDate = self.startDate;
    bookGuestVC.endDate = self.endDate;
    NSArray * roomsInSection = [[[self.datasource objectAtIndex:indexPath.section] rooms] allObjects];
    bookGuestVC.room = [roomsInSection objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:bookGuestVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}








@end








