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
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        _reservations = [context executeFetchRequest:request error:&error];
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
    newReservation.guest = newGuest; //I was going to set both of these to be weak as to avoid a retain cycle...
    //  But we have set rooms.hotel and hotel.rooms the same way without making the properties weak.
    //  What am I missing? Is this not a retain cycle? Or should we have set them all to be weak?
    
    newReservation.room.reservation = newReservation;
    
    NSError *saveError;
    BOOL isSaved = [context save:&saveError];
    
    completion(isSaved, saveError);
}

- (void)removeReservation:(Reservation *)reservation {
	
}

- (void)doesReservationExist:(Reservation *)reservation {
	
}

@end
