//
//  BookmarksViewController.m
//  CorePeptides
//
//  Created by Jordan on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController.h"

#import "Restaurant.h"
#import "RestaurantViewController.h"
#import "ShareUrMealAppDelegate.h"

static const NSInteger kTabSegmentedControlWidth = 200;


@implementation BookmarksViewController

@synthesize restaurants;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        
        self.title = @"Bookmarks";
        //self.tabBarItem.image = [UIImage imageNamed:@"all.png"];
        
        UITabBarItem *bookmarks = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
        self.tabBarItem = bookmarks;
        [bookmarks release];

		
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 NSLocalizedString(@"Name", @"Bookmarks Name Tab Title"),
											 NSLocalizedString(@"Location", @"Bookmarks Location Tab Title"), 
											 nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.navigationItem.titleView = segmentedControl;
	segmentedControl.selectedSegmentIndex = 0;
	CGRect segmentedControlFrame = segmentedControl.frame;
	segmentedControlFrame.size.width = kTabSegmentedControlWidth;
	segmentedControl.frame = segmentedControlFrame;
	[segmentedControl release];
	

	{
		NSManagedObjectContext* moc = [(ShareUrMealAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		NSFetchRequest* request = [[NSFetchRequest alloc] init];
		NSEntityDescription* entity = [NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:moc];
		[request setEntity:entity];
		
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
		
		NSError* error = nil;
		self.restaurants = [moc executeFetchRequest:request error:&error];
		if( error )
		{
			// TODO: handle error
		}
		[request release];
	}
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



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


#pragma mark TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.restaurants count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
		
	cell.textLabel.text = [[self.restaurants objectAtIndex:[indexPath row]] name];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Restaurant* restaurant = [self.restaurants objectAtIndex:[indexPath row]];
	RestaurantViewController* vc = [[RestaurantViewController alloc] initWithRestaurant:restaurant];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}


@end
