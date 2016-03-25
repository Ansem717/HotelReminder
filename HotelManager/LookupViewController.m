//
//  LookupViewController.m
//  HotelManager
//
//  Created by Andy Malik on 3/23/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//
//  Pieced together information from Slides, Documentation and Ray Wenderlich's tutorial for using NSFetchedResultsController
//  https://www.raywenderlich.com/999/core-data-tutorial-for-ios-how-to-use-nsfetchedresultscontroller

#import "LookupViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"
#import "Guest.h"
#import "Room.h"
#import "Hotel.h"

@interface LookupViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar * searchBar;
@property (strong, nonatomic) UITableView * searchTableView;
@property (strong, nonatomic) NSFetchedResultsController * fetchController;

@end

@implementation LookupViewController

- (NSFetchedResultsController *)fetchController {
    if (!_fetchController) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"room.roomNum" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        NSFetchedResultsController * tempFetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchController = tempFetchController;
        _fetchController.delegate = self;
    }
    return _fetchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Search"];
    NSError *error;
    if (![self.fetchController performFetch:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self makeItLookPretty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeItLookPretty {
        float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame)+20;
    
    self.searchBar = [[UISearchBar alloc]init];
    self.searchTableView = [[UITableView alloc]init];
    
    self.searchBar.delegate = self;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.searchTableView];
    
    [self.searchBar setPlaceholder:@"Name of Reservation Holder"];
    [self.searchBar setShowsCancelButton:YES];
    
    [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    
    NSDictionary *views = [[NSDictionary alloc]initWithObjects:@[self.searchBar, self.searchTableView] forKeys:@[@"bar", @"table"]];
    
    
    NSArray* searchBarX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bar]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    NSArray* searchTableViewX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    NSArray * allVertialConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[bar][table]|", navBarHeight]
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];

    
    [self.view addConstraints:searchBarX];
    [self.view addConstraints:searchTableViewX];
    [self.view addConstraints:allVertialConstraints];
    
    
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Reservation *currReservation = [self.fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ - %@: Room %@", currReservation.guest.firstName, currReservation.guest.lastName, currReservation.room.hotel.name, currReservation.room.roomNum];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    NSPredicate * predForName = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(guest.firstName like '%@') or (guest.lastName like '%@')", searchBar.text, searchBar.text]];
    
    [[self.fetchController fetchRequest] setPredicate:predForName];
    NSError *error;
    [self.fetchController performFetch:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]); //Well there was no error... it just didn't change... 
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [self.searchBar setText:@""];
}


#pragma mark - NSFetchedResultsConotroller Delegate

//Alright, so I could just 'change' some variable names around after copying and pasting... Well, I didn't copy and paste, but I did retype verbatim. Kind of the same, but it was allowed in my 301. The reason I felt it was OK here was because in the tutorial itself, Ray talks about how he copied this code over from Apple's documentation. If even this is too 'risky' for class, let me know, and I can do some extra reading or quizzes or something to prove knoweldge of concept.

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.searchTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.searchTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.searchTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.searchTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.searchTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.searchTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.searchTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.searchTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.searchTableView endUpdates];
}


@end

















