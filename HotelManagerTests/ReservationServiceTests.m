//
//  ReservationServiceTests.m
//  HotelManager
//
//  Created by Andy Malik on 3/24/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ReservationService.h"

@interface ReservationServiceTests : XCTestCase

@property (nonatomic) int finalNumber;

@end

@implementation ReservationServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testAddNumber {
    self.finalNumber = [ReservationService addNumber:1 with:2];
    XCTAssertEqual(self.finalNumber, 1+2);
}

- (void)testSingleton {
    XCTAssertNotNil([ReservationService shared]);
}











@end

















