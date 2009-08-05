//
//  BookmarksViewController.m
//  CorePeptides
//
//  Created by Jordan on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController.h"
#import "RestaurantViewController.h"

@implementation BookmarksViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        
        self.title = @"Bookmarks!";
        //self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
        
        UITabBarItem *bookmarks = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
        self.tabBarItem = bookmarks;
        [bookmarks release];
        

        
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


//- (IBAction)push:(id)sender {
//    RestaurantViewController *restaurantViewController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantView" bundle:nil];
//    [self.navigationController pushViewController:restaurantViewController animated:YES];
//    [restaurantViewController release];
//    
//    
//}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
