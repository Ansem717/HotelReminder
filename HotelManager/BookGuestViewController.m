//
//  BookGuestViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/22/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "BookGuestViewController.h"

@interface BookGuestViewController ()

@property (strong, nonatomic) UILabel * firstNameLabel;
@property (strong, nonatomic) UITextField * firstNameINPUT;
@property (strong, nonatomic) UILabel * lastNameLabel;
@property (strong, nonatomic) UITextField * lastNameINPUT;
@property (strong, nonatomic) UILabel * phoneNumberLabel;
@property (strong, nonatomic) UITextField * phoneNumberINPUT;
@property (strong, nonatomic) UIButton * saveButton;

@end

@implementation BookGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.startDate);
    NSLog(@"%@", self.endDate);
    NSLog(@"Room %@ - %@ beds for $%@.99 per night", self.room.roomNum, self.room.numOfBeds, self.room.rate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
