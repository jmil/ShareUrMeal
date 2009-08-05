//
//  RestaurantViewController.m
//  ShareUrMeal
//
//  Created by Jordan on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RestaurantViewController.h"

#import "Restaurant.h"


@interface RestaurantViewController ()
- (void) updateUIWithCurrentRestaurant;
@end


@implementation RestaurantViewController

@synthesize restaurant;
@synthesize nameLabel;
@synthesize locationLabel;


- (id) initWithRestaurant:(Restaurant*)aRestaurant
{
	if (self = [super initWithNibName:@"RestaurantView" bundle:nil]) 
	{
		self.restaurant = aRestaurant;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[self updateUIWithCurrentRestaurant];
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



- (void)dealloc
{
	[restaurant release];
    [super dealloc];
}


- (void) updateUIWithCurrentRestaurant
{
	self.nameLabel.text = self.restaurant.name;
	self.locationLabel.text = [NSString stringWithFormat:@"(%f, %f)", self.restaurant.latitude, self.restaurant.longitude];	
	self.title = self.restaurant.name;
}


#pragma mark Accessors

- (void) setRestaurant:(Restaurant*)rest
{
	[rest retain];
	[restaurant release];
	restaurant = rest;
	
	[self updateUIWithCurrentRestaurant];
}


@end
