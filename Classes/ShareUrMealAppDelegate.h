//
//  ShareUrMealAppDelegate.h
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class ShareViewController;

@interface ShareUrMealAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    UINavigationController *navigationController;
    
    ShareViewController *shareViewController;
}


- (IBAction)saveAction:sender;

@property (nonatomic, retain) IBOutlet ShareViewController *shareViewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

