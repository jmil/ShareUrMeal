//
//  ShareUrMealAppDelegate.m
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ShareUrMealAppDelegate.h"
#import "BookmarksViewController.h"


@implementation ShareUrMealAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    

    
    tabBarController = [[UITabBarController alloc] init];
    
    
    // Create a few view controllers
    UIViewController *redViewController = [[UIViewController alloc] init];
    redViewController.title = @"Calculator";
    
    UITabBarItem *calculator = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:1];
    calculator.title = @"hello";
    redViewController.tabBarItem = calculator;
    [calculator release];
    
    
    redViewController.tabBarItem.image = [UIImage imageNamed:@"faves.png"];
    redViewController.view.backgroundColor = [UIColor redColor];
    
    UIViewController *blueViewController = [[UIViewController alloc] init];
    blueViewController.title = @"About";
    blueViewController.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    blueViewController.view.backgroundColor = [UIColor blueColor];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    
    BookmarksViewController *bookmarksViewController = [[BookmarksViewController alloc] initWithNibName:@"BookmarksView" bundle:nil];
    
    [navigationController pushViewController:bookmarksViewController animated:NO];
    [bookmarksViewController release];
    
    // Add them as children of the tab bar controller
    tabBarController.viewControllers = [NSArray arrayWithObjects:redViewController, navigationController, blueViewController, nil];
    
    
    // Don't forget memory management
    [redViewController release];
    [blueViewController release];
    [navigationController release];
    
    [window addSubview:tabBarController.view];
    
    
    
    
	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ShareUrMeal.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [tabBarController release];
	[window release];
	[super dealloc];
}


@end

