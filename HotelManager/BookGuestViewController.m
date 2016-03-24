//
//  BookGuestViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/22/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "BookGuestViewController.h"
#import "AppDelegate.h"
#import "Guest.h"
#import "Reservation.h"
#import "ReservationService.h"

@interface BookGuestViewController ()

@property (strong, nonatomic) UILabel * firstNameLabel;
@property (strong, nonatomic) UITextField * firstNameINPUT;
@property (strong, nonatomic) UILabel * lastNameLabel;
@property (strong, nonatomic) UITextField * lastNameINPUT;
@property (strong, nonatomic) UILabel * emailLabel;
@property (strong, nonatomic) UITextField * emailINPUT;
@property (strong, nonatomic) UIButton * saveButton;

@end

@implementation BookGuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"Guest Name"];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupView {
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame)+40;
    
    self.firstNameLabel = [[UILabel alloc]init];
    self.firstNameINPUT = [[UITextField alloc]init];
    self.lastNameLabel = [[UILabel alloc]init];
    self.lastNameINPUT = [[UITextField alloc]init];
    self.emailLabel = [[UILabel alloc]init];
    self.emailINPUT = [[UITextField alloc]init];
    self.saveButton = [[UIButton alloc]init];
    
    self.firstNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstNameINPUT.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameINPUT.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailINPUT.translatesAutoresizingMaskIntoConstraints = NO;
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.firstNameLabel];
    [self.view addSubview:self.firstNameINPUT];
    [self.view addSubview:self.lastNameLabel];
    [self.view addSubview:self.lastNameINPUT];
    [self.view addSubview:self.emailLabel];
    [self.view addSubview:self.emailINPUT];
    [self.view addSubview:self.saveButton];
    
    [self.firstNameLabel setText:@"First Name:"];
    [self.firstNameLabel setTextColor:[UIColor blackColor]];
    [self.firstNameLabel setFont:[UIFont fontWithName:@"Arial" size:19]];
    
    [self.firstNameINPUT setPlaceholder:@"John"];
    [self.firstNameINPUT setTextColor:[UIColor blackColor]];
    [self.firstNameINPUT setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.lastNameLabel setText:@"Last Name:"];
    [self.lastNameLabel setTextColor:[UIColor blackColor]];
    [self.lastNameLabel setFont:[UIFont fontWithName:@"Arial" size:19]];
    
    [self.lastNameINPUT setPlaceholder:@"Smith"];
    [self.lastNameINPUT setTextColor:[UIColor blackColor]];
    [self.lastNameINPUT setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.emailLabel setText:@"E-mail:"];
    [self.emailLabel setTextColor:[UIColor blackColor]];
    [self.emailLabel setFont:[UIFont fontWithName:@"Arial" size:19]];
    
    [self.emailINPUT setPlaceholder:@"name@example.com"];
    [self.emailINPUT setTextColor:[UIColor blackColor]];
    [self.emailINPUT setBorderStyle:UITextBorderStyleRoundedRect];
    
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setAlpha:0.3];
    [self.saveButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
    
    NSDictionary *views = [[NSDictionary alloc]initWithObjects:@[self.firstNameLabel, self.firstNameINPUT, self.lastNameLabel, self.lastNameINPUT, self.emailLabel, self.emailINPUT, self.saveButton] forKeys:@[@"firstLabel", @"firstInput", @"lastLabel", @"lastInput", @"emailLabel", @"emailInput", @"save"]];
    
    
    NSArray* firstNameX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[firstLabel(100)]-20-[firstInput]-20-|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    NSArray * firstNameLabelY = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[firstLabel]", navBarHeight+3]
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    
    NSArray * firstNameInputY = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[firstInput]", navBarHeight]
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [self.view addConstraints:firstNameX];
    [self.view addConstraints:firstNameLabelY];
    [self.view addConstraints:firstNameInputY];
    
    NSArray* lastNameX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lastLabel]-20-[lastInput]-20-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    NSArray * lastNameLabelY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstInput]-23-[lastLabel]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray * lastNameInputY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstInput]-20-[lastInput]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    [self.view addConstraints:lastNameX];
    [self.view addConstraints:lastNameLabelY];
    [self.view addConstraints:lastNameInputY];
    
    NSArray* emailX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[emailLabel]-20-[emailInput]-20-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    NSArray * emailLabelY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastInput]-23-[emailLabel]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    NSArray * emailInputY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastInput]-20-[emailInput]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
    [self.view addConstraints:emailX];
    [self.view addConstraints:emailLabelY];
    [self.view addConstraints:emailInputY];
    
    NSArray* saveButtonX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[save]-20-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    NSArray * saveButtonY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailInput]-20-[save]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [self.view addConstraints:saveButtonX];
    [self.view addConstraints:saveButtonY];
    
    [self.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.lastNameINPUT queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.saveButton.enabled = ![self.firstNameINPUT.text isEqualToString:@""] && ![self.lastNameINPUT.text isEqualToString:@""];
        self.saveButton.alpha = self.saveButton.enabled ? 1.0 : 0.3;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:self.firstNameINPUT queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.saveButton.enabled = ![self.firstNameINPUT.text isEqualToString:@""] && ![self.lastNameINPUT.text isEqualToString:@""];
        self.saveButton.alpha = self.saveButton.enabled ? 1.0 : 0.3;
    }];

    
}



- (void)saveButtonClicked:(UIButton *)sender{
    [[ReservationService shared]addReservationWithStartTime:self.startDate
                                                 andEndTime:self.endDate
                                                    andRoom:self.room
                                          andGuestFirstName:self.firstNameINPUT.text
                                           andGuestLastName:self.lastNameINPUT.text
                                              andGuestEmail:self.emailINPUT.text
                                                 completion:^(BOOL success, NSError *error)
    {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else if (success) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Reservation Saved" message:@"Thank you for reserving. An e-mail will be sent to you shortly." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

@end
























