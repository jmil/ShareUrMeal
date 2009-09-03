//
//  AccountViewController.h
//  ShareUrMeal
//
//  Created by Andy Mroczkowski on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountViewController : UIViewController
{
	UIView* contentView;
	UIView* loggedInView;
	UINavigationBar* loginSignupToggleBar;
	
	BOOL isLoggedIn;  // TODO: improve
}

@property (nonatomic, retain) IBOutlet UIView* loggedInView;
@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic, retain) IBOutlet UINavigationBar* loginSignupToggleBar;

@property (nonatomic, assign) BOOL isLoggedIn;

- (IBAction) cancel:(id)sender;
- (IBAction) logout:(id)sender;

@end
