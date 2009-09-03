//
//  ShareUrMealAppDelegate.h
//  ShareUrMeal
//
//  Created by Jordan on 7/28/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface ShareUrMealAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    
    IBOutlet UITabBarController *tabBarController;
}

- (IBAction)saveAction:sender;

- (IBAction) showAccountView:(id)sender;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

