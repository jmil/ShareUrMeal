//
//  AccountViewController.m
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"

#import "SignUpViewController.h"

@implementation AccountViewController

@synthesize loginSignupToggleBar;
@synthesize isLoggedIn;
@synthesize loggedInView;
@synthesize contentView;

- (id) init
{
	self = [super initWithNibName:@"AccountViewController" bundle:nil];
	if (self != nil)
	{
		
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if( self.isLoggedIn )
	{
		self.loggedInView.frame = self.contentView.bounds;
		[self.contentView addSubview:self.loggedInView];
	}
	else
	{
		[self.view addSubview:self.loginSignupToggleBar];
		
		CGRect contentViewRect = self.contentView.frame;
		contentViewRect.origin.y += self.loginSignupToggleBar.bounds.size.height;
		contentViewRect.size.height -= self.loginSignupToggleBar.bounds.size.height;
		self.contentView.frame = contentViewRect;
		
		SignUpViewController* signUpController = [[SignUpViewController alloc] init];
		signUpController.view.frame = self.contentView.bounds;
		[self.contentView addSubview:signUpController.view];
	}
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
	[loginSignupToggleBar release];
	[loggedInView release];
	[contentView release];
    [super dealloc];
}


- (IBAction) cancel:(id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction) logout:(id)sender
{
	
}


@end
