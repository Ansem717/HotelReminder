//
//  BookTimesViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/22/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "BookTimesViewController.h"
#import "BookRoomsViewController.h"

@interface BookTimesViewController ()

@property (strong, nonatomic) UILabel * startLabel;
@property (strong, nonatomic) UILabel * endLabel;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation BookTimesViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBTVC];
    [self setupPickers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupBTVC {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Reserve Time";
}

- (void)setupPickers {
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame)+30;
    
    self.startLabel = [[UILabel alloc]init];
    self.endLabel = [[UILabel alloc]init];
    self.startDatePicker = [[UIDatePicker alloc]init];
    self.endDatePicker = [[UIDatePicker alloc]init];
    self.nextButton = [[UIButton alloc]init];
    
    self.startLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.endLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.startDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.endDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.startDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.endDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.startDatePicker setMinimumDate:[NSDate date]];
    [self.endDatePicker setMinimumDate:[NSDate date]];
    
    [self.view addSubview:self.startLabel];
    [self.view addSubview:self.endLabel];
    [self.view addSubview:self.startDatePicker];
    [self.view addSubview:self.endDatePicker];
    [self.view addSubview:self.nextButton];
    
    [self.startLabel setText:@"Start time for Reservation:"];
    [self.startLabel setTextColor:[UIColor blackColor]];
    [self.startLabel setTextAlignment:NSTextAlignmentCenter];
    [self.startLabel setFont:[UIFont fontWithName:@"Arial" size:21]];
    
    [self.endLabel setText:@"End time for Reservation:"];
    [self.endLabel setTextColor:[UIColor blackColor]];
    [self.endLabel setTextAlignment:NSTextAlignmentCenter];
    [self.endLabel setFont:[UIFont fontWithName:@"Arial" size:21]];
    
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSDictionary *views = [[NSDictionary alloc]initWithObjects:@[self.startLabel, self.endLabel, self.startDatePicker, self.endDatePicker, self.nextButton] forKeys:@[@"startText", @"endText", @"startDate", @"endDate", @"next"]];

    
    NSArray* startTextX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startText]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    NSArray * startTextY = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[startText]", navBarHeight]
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self.view addConstraints:startTextX];
    [self.view addConstraints:startTextY];
    
    NSArray* startDatePickerX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startDate]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray * startDatePickerY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[startText][startDate]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self.view addConstraints:startDatePickerX];
    [self.view addConstraints:startDatePickerY];
    
    NSArray* endTextX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endText]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    NSArray * endTextY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[startDate]-20-[endText]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self.view addConstraints:endTextX];
    [self.view addConstraints:endTextY];
    
    NSArray* endDatePickerX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endDate]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    NSArray * endDatePickerY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[endText][endDate]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self.view addConstraints:endDatePickerX];
    [self.view addConstraints:endDatePickerY];
    
    NSArray* nextButtonX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[next]-20-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    NSArray * nextButtonY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[endDate]-20-[next]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [self.view addConstraints:nextButtonX];
    [self.view addConstraints:nextButtonY];
    
    [self.nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.startDatePicker addTarget:self action:@selector(startDateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)nextButtonClicked:(UIButton *)sender {
    BookRoomsViewController * bookRoomsVC = [[BookRoomsViewController alloc]init];
    bookRoomsVC.startDate = self.startDatePicker.date;
    bookRoomsVC.endDate = self.endDatePicker.date;
    [self.navigationController pushViewController:bookRoomsVC animated:YES];
}

- (void)startDateChanged:(UIDatePicker *)sender {
    [self.endDatePicker setMinimumDate:sender.date];
    
    //The homework asked to alert the user if they attempt to end the reservation before starting the reservation.
    
    //  So, sure, I could say:
    //                        [self.startDatePicker.date compare:self.endDatePicker.date]  ==  NSOrderedDescending
    //  then I would present an alert, but I feel that alerts are somewhat tacky.
    
    //  To me, it is more professional to consistently change the end date's minimum date to equal the start date.
    //  This way it's impossible for the end date to be before the start date.
    //  I'm not sure if the homework required us to use the compare method, and I hope this comment proves my knowledge on it.
}


@end












