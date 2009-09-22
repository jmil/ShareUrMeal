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


@interface AccountViewController ()
- (void)loadLoginView;
- (void)loadSignupView;
@end


@implementation AccountViewController

@synthesize loginSignupToggleBar;
@synthesize isLoggedIn;
@synthesize loggedInView;
@synthesize contentView;
@synthesize signUpController;
@synthesize loginController;
@synthesize authenticateButton;
@synthesize toolBar;
@synthesize keyboardDismissalTimer;





- (void)dealloc {
    self.signUpController = nil;
    self.loginController = nil;
    self.toolBar = nil;
    self.keyboardDismissalTimer = nil;
	[loginSignupToggleBar release];
	[loggedInView release];
	[contentView release];
    [super dealloc];
}


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
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    
}

- (IBAction) toggle:(id)sender{
        
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0){
        
        [self loadLoginView];
        
    }else {
        
        [self loadSignupView];
    }

}


- (void)loadLoginView{
    
    
    if(signUpController!=nil){
        
        [signUpController viewWillDisappear:NO];
        [signUpController.view removeFromSuperview];

    }
    
    authenticateButton.title = @"Log In";
    
    if(loginController==nil)
        self.loginController = [[[LoginViewController alloc] init] autorelease];
    
    loginController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:loginController.view];
    
    [loginController viewWillAppear:NO];
}

- (void)loadSignupView{
    
    
    if(loginController!=nil){
        
        [loginController viewWillDisappear:NO];
        [loginController.view removeFromSuperview];

    }
    
    authenticateButton.title = @"Sign Up";

    
    if(signUpController==nil)
        self.signUpController = [[[SignUpViewController alloc] init] autorelease];
    
    signUpController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:signUpController.view];
    
    [signUpController viewWillAppear:NO];
    
}

- (IBAction) authenticate:(id)sender{
    
    if([loginController.view superview]!=nil){
        
        [loginController login];
        
    }else{
        
        [signUpController signUp];
        
    }

}

- (void)keyboardWillShow:(NSNotification *)note{
    
    [keyboardDismissalTimer invalidate];
    self.keyboardDismissalTimer = nil;
    
    if(toolBar.frame.origin.y>300){
        
        [self.view bringSubviewToFront:toolBar];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        CGRect r  = toolBar.frame;
        CGRect t;
        [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &t];
        r.origin.y -=  t.size.height;
        toolBar.frame = r;
        
        if([signUpController.view superview]!=nil){
            
            CGRect frame = signUpController.view.frame;
            frame.size.height -= t.size.height;
            signUpController.view.frame = frame;
            
        }     
        
        [UIView commitAnimations];
        
        
           
    }
    
}

- (void)keyboardWillHide:(NSNotification *)note{
    
    self.keyboardDismissalTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(animateToolBarToOriginalPosition) userInfo:nil repeats:NO];
        
}

- (void)animateToolBarToOriginalPosition{
    
    self.keyboardDismissalTimer = nil;
    
    [self.view bringSubviewToFront:toolBar];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect r  = toolBar.frame;
    r.origin.y = 416;
    toolBar.frame = r;
    
    if([signUpController.view superview]!=nil){
        
        CGRect frame = signUpController.view.frame;
        frame.size.height  = 480-44-44;
        signUpController.view.frame = frame;        
    }    
    
    [UIView commitAnimations];
    
        
        
    
}


- (void)dismissWithNote:(NSNotification*)note{
    
    [self dismissModalViewControllerAnimated:YES];

}


- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didSignUpNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    
    if([loginController.view superview]==nil)
        self.loginController = nil;
    
    if([signUpController.view superview]==nil)
        self.signUpController = nil;

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction) cancel:(id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (IBAction) logout:(id)sender
{
	
}


@end
