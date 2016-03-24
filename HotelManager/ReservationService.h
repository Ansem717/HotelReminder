//
//  ReservationService.h
//  HotelManager
//
//  Created by Andy Malik on 3/23/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reservation.h"
#import "Room.h"
#import "Guest.h"

typedef void(^savedCompletion)(BOOL success, NSError *error);

@interface ReservationService : NSObject

@property (strong, nonatomic) NSArray<Reservation *> *reservations;

+ (instancetype)shared;

- (void)addReservationWithStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andRoom:(Room *)room andGuestFirstName:(NSString *)guestFirstName andGuestLastName:(NSString *)guestLastName andGuestEmail:(NSString *)guestEmail completion:(savedCompletion)completion;

- (void)removeReservation:(Reservation *)reservation;
- (void)doesReservationExistWithStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime andRoom:(Room *)room completion:(void(^)(BOOL doesExist))completion;

@end
