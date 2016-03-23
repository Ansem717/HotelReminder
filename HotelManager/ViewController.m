//
//  ViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/21/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "ViewController.h"
#import "HotelsViewController.h"
#import "BookTimesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    [self setupCustomLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupCustomLayout {
    [self.navigationItem setTitle:@"Hotel Manager"];
}

- (void)setupViewController {
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame)+20;
    
    UIButton *browseButton = [UIButton new];
    UIButton *bookButton = [UIButton new];
    UIButton *lookupButton = [UIButton new];
    
    [browseButton setTitle:@"Browse" forState:UIControlStateNormal];
    [bookButton setTitle:@"Make Reservation" forState:UIControlStateNormal];
    [lookupButton setTitle:@"Search" forState:UIControlStateNormal];
    
    [browseButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.75 alpha:1.0]];
    [bookButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.75 blue:1.0 alpha:1.0]];
    [lookupButton setBackgroundColor:[UIColor colorWithRed:0.75 green:1.0 blue:1.0 alpha:1.0]];
    
    [browseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lookupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [browseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bookButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lookupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:browseButton];
    [self.view addSubview:bookButton];
    [self.view addSubview:lookupButton];
    
    NSDictionary *views = [[NSDictionary alloc]initWithObjects:@[browseButton, bookButton, lookupButton] forKeys:@[@"browseButton", @"bookButton", @"lookupButton"]];
    
    for (NSString *key in views.keyEnumerator) {
        NSArray* eachConstraintX = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", key]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
        [self.view addConstraints:eachConstraintX];
    }
    
    NSArray* verticalConstraintsBrowse = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[browseButton]", navBarHeight]
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:verticalConstraintsBrowse];
    NSArray* verticalConstraintsBook = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[browseButton][bookButton][lookupButton]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:verticalConstraintsBook];
    NSArray* verticalConstraintsLook = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lookupButton]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [self.view addConstraints:verticalConstraintsLook];
    
    NSArray *browseButtonHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[browseButton(==bookButton)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
    NSArray *bookButtonHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bookButton(==browseButton)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
    NSArray *lookupButtonHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lookupButton(==browseButton)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
    
    [self.view addConstraints:browseButtonHeight];
    [self.view addConstraints:bookButtonHeight];
    [self.view addConstraints:lookupButtonHeight];
    
    [browseButton addTarget:self action:@selector(browseButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [bookButton addTarget:self action:@selector(bookButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [lookupButton addTarget:self action:@selector(lookupButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [browseButton setTag:101];
    [bookButton setTag:102];
    [lookupButton setTag:103];
}

- (void)browseButtonSelected:(UIButton *)sender {
    [self.navigationController pushViewController:[[HotelsViewController alloc]init] animated:YES];
}

- (void)bookButtonSelected:(UIButton *)sender {
    [self.navigationController pushViewController:[[BookTimesViewController alloc]init] animated:YES];
}

- (void)lookupButtonSelected:(UIButton *)sender {
    NSLog(@"Searching for reservations...");
}






@end
