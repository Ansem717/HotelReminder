//
//  ReservationService.m
//  HotelManager
//
//  Created by Andy Malik on 3/23/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "ReservationService.h"
#import "AppDelegate.h"

#define DELEGATE AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define CONTEXT NSManagedObjectContext *context = delegate.managedObjectContext
#define DELEGATE_CONTEXT DELEGATE; CONTEXT



@implementation ReservationService

- (NSArray<Reservation *> *)reservations {
    if (!_reservations) {
        DELEGATE_CONTEXT;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        NSError *error;
        _reservations = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return _reservations;
}

+ (instancetype)shared {
    static ReservationService * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (void)addReservationWithStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andRoom:(Room *)room andGuestFirstName:(NSString *)guestFirstName andGuestLastName:(NSString *)guestLastName andGuestEmail:(NSString *)guestEmail completion:(savedCompletion)completion {
    
    DELEGATE_CONTEXT;
    Guest * newGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    
    newGuest.firstName = guestFirstName;
    newGuest.lastName = guestLastName;
    newGuest.email = guestEmail;
    
    Reservation * newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    
    newReservation.startDate = startTime;
    newReservation.endDate = endTime;
    newReservation.room = room;
    
    newGuest.reservation = newReservation;
    newReservation.guest = newGuest;
    
    newReservation.room.reservation = newReservation;
    
    NSError *saveError;
    BOOL isSaved = [context save:&saveError];
    completion(isSaved, saveError);
}

- (void)removeReservation:(Reservation *)reservation {
	
}

- (void)doesReservationExistWithStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andRoom:(Room *)room completion:(void(^)(BOOL doesExist))completion {
    DELEGATE_CONTEXT;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
    NSError *error;
    NSArray * result = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        abort();
    }
    for (Reservation *storedReservation in result) {
        if ([storedReservation.room isEqual:room]) {
            NSDate * laterStart = [storedReservation.startDate laterDate:startTime];
            NSDate * earlierEnd = [storedReservation.endDate earlierDate:endTime];
            if ([laterStart compare:earlierEnd] == NSOrderedAscending) {
                completion(YES);
            }
        }
    }
    completion(NO);
}











@end









