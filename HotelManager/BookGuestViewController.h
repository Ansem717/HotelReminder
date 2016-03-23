//
//  BookGuestViewController.h
//  HotelManager
//
//  Created by Andy Malik on 3/22/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface BookGuestViewController : UIViewController

@property (strong, nonatomic) NSDate * startDate;
@property (strong, nonatomic) NSDate * endDate;
@property (strong, nonatomic) Room * room;

@end
