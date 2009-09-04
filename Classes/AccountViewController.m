//
//  AccountViewController.m
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"

#import "SignUpViewController.h"
#import "LoginViewController.h"

@implementation AccountViewController

@synthesize loginSignupToggleBar;
@synthesize isLoggedIn;
@synthesize loggedInView;
@synthesize contentView;
@synthesize signUpController;
@synthesize loginController;


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
		
		[self loadLoginView];
	}
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWithNote:) name:didSignUpNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWithNote:) name:didLoginNotification object:nil];

    
}

- (IBAction) toggle:(id)sender{
    
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0){
        
        [self loadLoginView];
        
    }else {
        
        [self loadSignupView];
    }

}


- (void)loadLoginView{
    
    if(signUpController!=nil)
        [loginController.view removeFromSuperview];
    
    if(loginController==nil)
        self.loginController = [[[LoginViewController alloc] init] autorelease];
    
    loginController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:loginController.view];
    
}

- (void)loadSignupView{
    
    if(loginController!=nil)
        [loginController.view removeFromSuperview];
    
    if(signUpController==nil)
        self.signUpController = [[[SignUpViewController alloc] init] autorelease];
    
    signUpController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:signUpController.view];
    
    
}

- (void)dismissWithNote:(NSNotification*)note{
    
    [self dismissModalViewControllerAnimated:YES];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didSignUpNotification object:nil];
    
    [super viewWillDisappear:animated];

}

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
    self.signUpController = nil;
    self.loginController = nil;
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
