//
//  AppDelegate.m
//  HotelManager
//
//  Created by Andy Malik on 3/21/16.
//  Copyright © 2016 Ansem717. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Hotel.h"
#import "Room.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ViewController *viewController;

@end

@implementation AppDelegate

- (void)setUpRVC {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.viewController = [[ViewController alloc]init];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.viewController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
}

- (void)bootstrapApp {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
    NSError *error;
    NSInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    
    if (count == 0 && !error) {
        NSDictionary *hotels = [NSDictionary new];
        NSDictionary *rooms = [NSDictionary new];
        NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"hotels" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        
        NSError *jsonError;
        
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error serializing JSON");
            return;
        }
        
        hotels = rootObject[@"Hotels"];
        
        for (NSDictionary *hotel in hotels) {
            Hotel *newHotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
            
            newHotel.name = hotel[@"name"];
            newHotel.location = hotel[@"location"];
            newHotel.stars = hotel[@"stars"];
            
            NSMutableSet *allRooms = [NSMutableSet new];
            
            rooms = hotel[@"rooms"];
            
            for (NSDictionary *room in rooms) {
                Room *newRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
                
                newRoom.roomNum = room[@"number"];
                newRoom.numOfBeds = room[@"beds"];
                newRoom.rate = room[@"rate"];
                
                newRoom.hotel = newHotel;
    
                [allRooms addObject:newRoom];
            }
            
            newHotel.rooms = allRooms;
            
        }
        
        NSError *saveError;
        BOOL isSaved = [self.managedObjectContext save:&saveError];
        
        if (isSaved) {
//            NSLog(@"Saved!");
        } else {
            NSLog(@"%@", [saveError localizedDescription]);
        }
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpRVC];
    [self bootstrapApp];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotelManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotelManager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
